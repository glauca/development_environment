## [13.3.6 SET TRANSACTION Syntax](http://dev.mysql.com/doc/refman/5.6/en/set-transaction.html)

~~~mysql
SET [GLOBAL | SESSION] TRANSACTION
    transaction_characteristic [, transaction_characteristic] ...

transaction_characteristic:
    ISOLATION LEVEL level
  | READ WRITE
  | READ ONLY

level:
     REPEATABLE READ
   | READ COMMITTED
   | READ UNCOMMITTED
   | SERIALIZABLE
~~~

上面的语句定义了事务特征。一个或多个特征通过逗号分隔。这些特征设置了事务的 [isolation level](http://dev.mysql.com/doc/refman/5.6/en/glossary.html#glos_isolation_level) or access mode。 isolation level 是在用在 `InnoDB`。

In addition, `SET TRANSACTION` can include an optional `GLOBAL` or `SESSION` keyword to indicate the scope of the statement.


#### Scope of Transaction Characteristics

可以设置事务的特征是针对全局的还是当前会话的还是下一个事务的。

+ **GLOBAL** 关键字，后续的所有会话都会收到影响，之前的不受。
+ **SESSION** 关键字，影响当前会话的所有后续事务。
+ 没有 **GLOBAL** 和 **SESSION** 关键字，影响当前会话的下一个事务(未开始的)。后续的事务会再次回到之前的隔离级别。

> A global change to transaction characteristics requires the **SUPER** privilege.

> `SET TRANSACTION` without `GLOBAL` or `SESSION `is not permitted while there is an active transaction:

~~~mysql
mysql> START TRANSACTION;
Query OK, 0 rows affected (0.02 sec)

mysql> SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ERROR 1568 (25001): Transaction characteristics can't be changed
while a transaction is in progress
~~~

在服务器启动的时候设置全局隔离层等级，使用 **--transaction-isolation=level** 选项或在配置文件里设置。级别选项使用破折号而不是空格，如 **READ-UNCOMMITTED**, **READ-COMMITTED**, **REPEATABLE-READ**, or **SERIALIZABLE**。例如，

~~~mysql
[mysqld]
transaction-isolation = REPEATABLE-READ
~~~

可以使用 *tx_isolation* 系统变量在服务器运行的时候查看和设置隔离级别

~~~mysql
SELECT @@GLOBAL.tx_isolation, @@tx_isolation;
SET GLOBAL tx_isolation='REPEATABLE-READ';
SET SESSION tx_isolation='SERIALIZABLE';
~~~

类似的，在服务器启动或运行的时候，使用 **--transaction-read-only** option or **tx_read_only** system variable 设置事务范围模式。默认是 OFF (read/write) but can be set to ON for a default mode of read only.

用 *tx_isolation* or *tx_read_only* 设置全局或会话的隔离级别、访问模式和用 `SET GLOBAL TRANSACTION` or `SET SESSION TRANSACTION` 一样。

#### Details and Usage of Isolation Levels

InnoDB支持全部事务隔离级别。默认级别是 `REPEATABLE READ` [`ACID`](http://dev.mysql.com/doc/refman/5.6/en/glossary.html#glos_acid)。最高等级是 `SERIALIZABLE` ，使用在特定场合，如[XA](http://dev.mysql.com/doc/refman/5.6/en/glossary.html#glos_xa)

+ REPEATABLE READ

InnoDB 默认的级别。[consistent reads](http://dev.mysql.com/doc/refman/5.6/en/glossary.html#glos_consistent_read) && [Section 14.3.4, “Consistent Nonlocking Reads”](http://dev.mysql.com/doc/refman/5.6/en/innodb-consistent-read.html)

For locking reads (SELECT with FOR UPDATE or LOCK IN SHARE MODE), UPDATE, and DELETE statements, locking depends on whether the statement uses a unique index with a unique search condition, or a range-type search condition. For a unique index with a unique search condition, InnoDB locks only the index record found, not the gap before it. For other search conditions, InnoDB locks the index range scanned, using gap locks or next-key locks to block insertions by other sessions into the gaps covered by the range.

+ READ COMMITTED
+ READ UNCOMMITTED
+ SERIALIZABLE

> For additional information about isolation levels and InnoDB transactions, see [Section 14.3, “InnoDB Transaction Model and Locking”](http://dev.mysql.com/doc/refman/5.6/en/innodb-transaction-model.html).

> [MySQL数据库事务隔离级别(Transaction Isolation Level)](http://www.cnblogs.com/zemliu/archive/2012/06/17/2552301.html)

#### Transaction Access Mode

As of MySQL 5.6.5，访问模式可以通过 `SET TRANSACTION` 设置，默认是 `READ WRITE`。
`READ ONLY` 只允许读不允许写。
`READ ONLY` 和 `READ WRITE` 不允许同时设置。
在读模式下，`TEMPORARY` 表可以使用DML语句更新，但DDL语句不允许。