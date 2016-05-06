### [13.3.5.3 Table-Locking Restrictions and Conditions](http://dev.mysql.com/doc/refman/5.6/en/lock-tables-restrictions.html)

使用 [`KILL`](http://dev.mysql.com/doc/refman/5.6/en/kill.html) 终止会话等到表锁

使用了 [`INSERT DELAYED`](http://dev.mysql.com/doc/refman/5.6/en/insert-delayed.html) 的表就不要用锁了，`INSERT DELAYED` 使用的是单独的进程而不是会话。

`LOCK TABLES` and `UNLOCK TABLES` cannot be used within stored programs.

Tables in the **performance**_**schema** database cannot be locked with `LOCK TABLES`, except the **setup**_**xxx** tables.

The following statements are prohibited while a `LOCK TABLES` statement is in effect: `CREATE TABLE`, `CREATE TABLE ... LIKE`, `CREATE VIEW`, `DROP VIEW`, and DDL statements on stored functions and procedures and events.

对于有些操作，**mysql** 数据库的系统表必须能访问，例如

~~~mysql
mysql.help_category
mysql.help_keyword
mysql.help_relation
mysql.help_topic
mysql.proc
mysql.time_zone
mysql.time_zone_leap_second
mysql.time_zone_name
mysql.time_zone_transition
mysql.time_zone_transition_type
~~~

> If you want to explicitly place a `WRITE` lock on any of those tables with a `LOCK TABLES`statement, the table must be the only one locked; no other table can be locked with the same statement.


通常情况下不需要锁表，单个 `UPDATE` 是原子性的；其他的会话不会干扰当前的SQL语句执行。然而，有些情况锁表会产生有利情况：

+ 在一系列 **MYISAM** 表上进行多个操作，加锁会更快。通常，**MYISAM** 表在进行每个SQL语句后会刷新key缓存，如果是使用了锁，只有在使用了 `UNLOCK TABLES` 后才会刷新，这会加快插入、更新和删除操作。

负面，The downside to locking the tables is that no session can update a READ-locked table (including the one holding the lock) and no session can access a WRITE-locked table other than the one holding the lock.

+ 在不支持事务的表上要想确保没有其他会话修改表必须使用 `LOCK TABLES`。例子：

~~~mysql
LOCK TABLES trans READ, customer WRITE;
SELECT SUM(value) FROM trans WHERE customer_id=some_id;
UPDATE customer
  SET total_value=sum_from_previous_statement
  WHERE customer_id=some_id;
UNLOCK TABLES;
~~~

> Without LOCK TABLES, it is possible that another session might insert a new row in the trans table between execution of the SELECT and UPDATE statements.

> You can avoid using LOCK TABLES in many cases by using relative updates (UPDATE customer SET value=value+new_value) or the LAST_INSERT_ID() function.