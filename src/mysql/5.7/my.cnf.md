
[my.cnf 读取顺序](http://dev.mysql.com/doc/refman/5.7/en/option-files.html)

1. /etc/my.cnf
1. /etc/mysql/my.cnf
1. /usr/local/mysql/etc/my.cnf
1. ~/.my.cnf

~~~mysql
[client]
# default-character-set = utf8
# pager = more
port = 3306
socket = /usr/local/mysql/data/mysqld.sock

[mysqladmin]

[mysqldump]

[mysqlimport]

[mysqlshow]

[mysqlslap]

[mysql.server]

[mysqld_safe]
socket = /usr/local/mysql/data/mysqld.sock
nice = 0

[mysqld]
user = mysql
pid-file = /usr/local/mysql/data/mysqld.pid
socket = /usr/local/mysql/data/mysqld.sock
basedir = /usr/local/mysql
datadir = /usr/local/mysql/data
tmpdir = /tmp

log-error = /usr/local/mysql/data/mysqld.err

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

# 不使用 DNS
skip-name-resolve
~~~
