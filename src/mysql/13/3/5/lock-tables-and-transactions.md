### [13.3.5.1 Interaction of Table Locking and Transactions](http://dev.mysql.com/doc/refman/5.6/en/lock-tables-and-transactions.html)

`LOCK TABLES` and `UNLOCK TABLES` 和 `Transactions` 的关系

+ `LOCK TABLES` 在试图锁表之前会隐式提交所有事务。
+ `UNLOCK TABLES` 只有在 `LOCK TABLES` 已经锁表的情况下才会隐式提交事务。
+ 开始一个事务会隐式提交当前事务并是否表锁。
+ `FLUSH TABLES WITH READ LOCK`
+ The correct way to use `LOCK TABLES` and UNLOCK TABLES with transactional tables, such as `InnoDB` tables, is to begin a transaction with SET autocommit = 0 (not `START TRANSACTION`) followed by `LOCK TABLES`, and to not call `UNLOCK TABLES` until you commit the transaction explicitly.
~~~mysql
SET autocommit=0;
LOCK TABLES t1 WRITE, t2 READ, ...;
... do something with tables t1 and t2 here ...
COMMIT;
UNLOCK TABLES;
~~~
+ `ROLLBACK` does not release table locks.