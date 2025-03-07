#!/bin/bash

JUMP_NODE=$1
NAME_NODE=$2
TEAM_USER=$3
TEAM_PASSWORD=$4
HADOOP_USER=$5
HADOOP_PASSWORD=$6
HIVE_USER=$7
HIVE_PASSWORD=$8

ssh $TEAM_USER@$JUMP_NODE << EOF

ssh $TEAM_USER@$NAME_NODE << EOL

sudo apt install -y postgresql

sudo -i -u postgres << EOL2

psql << SQL
CREATE DATABASE metastore;
CREATE USER $HIVE_USER WITH PASSWORD '$HIVE_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE "metastore" TO $HIVE_USER;
ALTER DATABASE metastore OWNER TO $HIVE_USER;
\q
SQL
EOL2

exit

sudo vim /etc/postgresql/16/main/postgresql.conf
#меняем вручную

sudo vim /etc/postgresql/16/main/pg_hba.conf
#меняем вручную

sudo systemctl restart postgresql
exit
EOF

ssh $TEAM_USER@$JUMP_NODE << EOF
sudo apt install -y postgresql-client-16

sudo -i -u $HADOOP_USER << EOL

wget https://archive.apache.org/dist/hive/hive-4.0.0-alpha-2/apache-hive-4.0.0-alpha-2-bin.tar.gz
tar -xzvf apache-hive-4.0.0-alpha-2-bin.tar.gz
cd apache-hive-4.0.0-alpha-2-bin/lib/
wget https://jdbc.postgresql.org/download/postgresql-42.7.4.jar

vim ../conf/hive-site.xml
#меняем вручную

vim ~/.profile
#меняем вручную

source ~/.profile

hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /tmp
hdfs dfs -chmod g+w /user/hive/warehouse

cd ..
bin/schematool -dbType postgres --initSchema

hive --hiveconf hive.server2.enable.doAs=false --hiveconf hive.security.authorization.enabled=false --service hiveserver2 1>> /tmp/hs2.log 2>> /tmp/hs2.log &

beeline -u jdbc:hive2://$JUMP_NODE:5433 -n scott -p tiger
!q
EOL
EOF