## [2.10 Postinstallation Setup and Testing](http://dev.mysql.com/doc/refman/5.7/en/postinstallation.html)

1. Initializing the Data Directory
2. Starting the Server
3. Testing the Server
4. [Securing the Initial MySQL Accounts](./4.md)
5. [Starting and Stopping MySQL Automatically](./5.md)

二进制包和源代码包，必须手动初始化数据目录。[Section 2.10.1, “Initializing the Data Directory”](http://dev.mysql.com/doc/refman/5.7/en/data-directory-initialization.html)

如果在初始化数据目录的时候没有设置密码，为root账号设置密码。MySQL数据库会阻止未授权访问。

生成时区表 [Section 11.6, “MySQL Server Time Zone Support”](http://dev.mysql.com/doc/refman/5.7/en/time-zone-support.html)