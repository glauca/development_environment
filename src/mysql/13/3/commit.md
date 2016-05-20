## 13.3.1 START TRANSACTION, COMMIT, and ROLLBACK Syntax

~~~mysql
START TRANSACTION
    [transaction_characteristic [, transaction_characteristic] ...]

transaction_characteristic:
    WITH CONSISTENT SNAPSHOT
  | READ WRITE
  | READ ONLY

BEGIN [WORK]
COMMIT [WORK] [AND [NO] CHAIN] [[NO] RELEASE]
ROLLBACK [WORK] [AND [NO] CHAIN] [[NO] RELEASE]
SET autocommit = {0 | 1}
~~~

+ `START TRANSACTION` 或者 `BEGIN` 开始一个新事务
+ `COMMIT` 提交当前事务，使当前事务永久生效
+ `ROLLBACK` 回滚当前事务，取消掉当前事务
+ `SET autocommit` 开启或关闭当前会话默认自动提交模式

默认情况下，MySQL是开启 `autocommit` 模式的。一旦执行了更新语句，MySQL会永久存储修改到磁盘，并且不可回滚。

显式使用 `START TRANSACTION` 语句，会禁用 `autocommit`。直到使用了 `COMMIT or ROLLBACK` 才会使 `autocommit` 回到先前的状态。

`START TRANSACTION` 允许使用修饰来控制事务的特性。要使用多个修饰，用逗号隔开。

+ `WITH CONSISTENT SNAPSHOT` 一致性读快照，仅适用于InnoDB。类似于 START TRANSACTION 后跟 SELECT [参考 Section 14.3.4, “Consistent Nonlocking Reads“](http://dev.mysql.com/doc/refman/5.6/en/innodb-consistent-read.html)。一致性快照不会改变当前事务的隔离级别，因此仅适用于一致性读的隔离级别 [参考 isolation level](http://dev.mysql.com/doc/refman/5.6/en/glossary.html#glos_isolation_level)。WITH CONSISTENT SNAPSHOT 仅支持 REPEATABLE READ，其他的都会忽略掉。
+ `READ WRITE and READ ONLY` 设置事务的访问模式。他们允许或禁止事务中的表变化。`READ ONLY`严格限制事务修改或锁住对其他事务可见的事务或非事务表。

如果没有设置访问模式，默认的模式是 `READ WRITE`，`READ WRITE and READ ONLY` 不允许同时使用。
在 `READ ONLY` 模式中，使用 `TEMPORARY ` 关键字的DML语句创建的临时表是允许改变的。DDL语句是不允许改变永久表的。
[更多资料见 Section 13.3.6, “SET TRANSACTION Syntax”](http://dev.mysql.com/doc/refman/5.6/en/set-transaction.html)

要禁用 autocommit，仅针对会话级
~~~mysql
SET autocommit=0;
~~~

`AND CHAIN` 会产生一个新事物紧接着上一个事务，并且新事物的隔离级别和刚刚结束的一样。`RELEASE` 会让服务器在当前事务结束后断开与当前客户端的会话。

开始一个事务会导致任何等待的事务等到提交。
开始一个事务也会导致一个获得 `LOCK TABLES` 锁的表释放锁，尽管已经执行了 `UNLOCK TABLES`。
开始一个事务不会释放一个通过 `FLUSH TABLES WITH READ LOCK` 获得的读锁。

最好的结果，事务应该作用在使用了单安全事务存储引擎的表上。不然，会有一下问题：

+ 如果使用了多个事务引擎，例如InnoDB，并且隔离级别不是 `SERIALIZABLE`，可能一个事务提交了，另一个还在进行事务使用同样几个表会发现第一个事务只改变了个别表。事务的原子性不能保证混合引擎的一致性结果。（如果混合引擎不常使用，可以给每个单独的事务设置 `SET TRANSACTION ISOLATION LEVEL` 为 `SERIALIZABLE`）
+ 如果使用的表不是事务类型的，所有的改变都会立即被保存。
+ 通过事务更新了一个非事务表，使用 `ROLLBACK` 会导致 `ER_WARNING_NOT_COMPLETE_ROLLBACK` 警告。事务表的改变会回滚，非事务表不会改变。