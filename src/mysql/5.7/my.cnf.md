
my.cnf 读取顺序

~~~mysql
[client]
port = 3306
socket = /tmp/mysqld.sock

[mysqld]
datadir = /usr/local/mysql/data
socket = /tmp/mysqld.sock
user = mysql
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

[mysqld_safe]
socket = /tmp/mysqld.sock
log-error = /usr/local/mysql/mysqld.log
pid-file = /tmp/mysqld.pid
~~~