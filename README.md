# Введение в платформы данных. Домашнее задание №3

Инструкция содержит шаги для выполнения задания ***без использования автоматизированных скриптов***(везде где встречаются имена нод или адреса нужно вводить свои).

Попробовала сделать скрипты для автоматизированного выполнения без привязки к среде. 
Нужно сделать файл исполняемым:
```bash
chmod +x hive-init.sh
```
И запустить файл hive-init.sh, передав имена нод, имена пользователей и пароли в качестве параметров следующим образом:
```bash
./hive-init.sh <jump_node> <name_node> <team_user> <team_password> <hadoop_user> <hadoop_password> <hive_user> <hive_password>
```

