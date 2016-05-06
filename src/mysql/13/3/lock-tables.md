## [13.3.5 LOCK TABLES and UNLOCK TABLES Syntax](http://dev.mysql.com/doc/refman/5.6/en/lock-tables.html)

1. [Interaction of Table Locking and Transactions](./5/lock-tables-and-transactions.md)
2. [LOCK TABLES and Triggers](./5/lock-tables-and-triggers.md)
3. [Table-Locking Restrictions and Conditions](./5/lock-tables-restrictions.md)

~~~mysql
LOCK TABLES
    tbl_name [[AS] alias] lock_type
    [, tbl_name [[AS] alias] lock_type] ...

lock_type:
    READ [LOCAL]
  | [LOW_PRIORITY] WRITE

UNLOCK TABLES
~~~

MySQL允许客户端会话获得锁，或者在需要排外的时候阻止其他客户端会话修改表。一个客户端会话只能获得或者释放它自己的锁。一个会话不能活动其他会话的锁或释放其他会话的锁。

锁通常被用来模拟事务或者在更新表的时候获得更快的速度。

`LOCK TABLES` 显式的为当前的会话获得锁。表或者视图都可以获得锁。当然，必须有 `LOCK TABLES` 和 `SELECT` 的权限。

对于视图锁，`LOCK TABLES` 会把所有使用的基础表自动锁定到一个集合中。触发器中使用的表也会被隐式的锁定 [Section 13.3.5.2, “LOCK TABLES and Triggers”](http://dev.mysql.com/doc/refman/5.6/en/lock-tables-and-triggers.html)。

`UNLOCK TABLES` 显示的是否当前会话的表锁。`LOCK TABLES` 在获得一个新锁之前会隐式的释放掉当前会话的所有锁。

`UNLOCK TABLES` 的另一个用法是释放掉通过 `FLUSH TABLES WITH READ LOCK` 语句获得的全局读锁，`FLUSH TABLES WITH READ LOCK` 将允许你锁定所有数据库的所有表。

表的锁仅保护其他会话不合适的读或写操作。A session holding a `WRITE` lock can perform table-level operations such as `DROP TABLE` or `TRUNCATE TABLE`. For sessions holding a `READ` lock, `DROP TABLE` and `TRUNCATE TABLE` operations are not permitted.

The following discussion applies only to non-`TEMPORARY` tables. `LOCK TABLES` is permitted (but ignored) for a `TEMPORARY` table. No lock is necessary because no other session can see the table.

#### Rules for Lock Acquisition

READ [LOCAL] lock:

+ 获得读锁的当前会话能读表但不能写。
+ 一个表同时可以获得多个读锁。
+ 其他会话不用显示获得读锁就能读表。
+ The `LOCAL` modifier enables nonconflicting `INSERT` statements (concurrent inserts) by other sessions to execute while the lock is held. (See Section 8.11.3, “Concurrent Inserts”.) However, `READ LOCAL` cannot be used if you are going to manipulate the database using processes external to the server while you hold the lock. For `InnoDB` tables, `READ LOCAL` is the same as `READ`.

[LOW_PRIORITY] WRITE lock:

+ 获得写锁的会话可以对表进行读写操作。
+ 只有获得写锁的会话可以操作表，其他的会话都不可以，直到锁释放掉。
+ 在写锁期间，其他会话的锁请求会阻塞。
+ Use `WRITE` without `LOW_PRIORITY` instead.

`LOCK TABLES` 会堵塞直到其他的锁都释放掉。

While the locks thus obtained are held, the session can access only the locked tables.
~~~mysql
mysql> LOCK TABLES t1 READ;
mysql> SELECT COUNT(*) FROM t1;
+----------+
| COUNT(*) |
+----------+
|        3 |
+----------+
mysql> SELECT COUNT(*) FROM t2;
ERROR 1100 (HY000): Table 't2' was not locked with LOCK TABLES
~~~
Tables in the INFORMATION_SCHEMA database are an exception.

~~~mysql
mysql> LOCK TABLE t WRITE, t AS t1 READ;
mysql> INSERT INTO t SELECT * FROM t;
ERROR 1100: Table 't' was not locked with LOCK TABLES
mysql> INSERT INTO t SELECT * FROM t AS t1;
~~~

~~~mysql
mysql> LOCK TABLE t READ;
mysql> SELECT * FROM t AS myalias;
ERROR 1100: Table 'myalias' was not locked with LOCK TABLES
~~~

~~~mysql
mysql> LOCK TABLE t AS myalias READ;
mysql> SELECT * FROM t;
ERROR 1100: Table 't' was not locked with LOCK TABLES
mysql> SELECT * FROM t AS myalias;
~~~

写锁要比读锁的优先级高。

#### Rules for Lock Release

+ A session can release its locks explicitly with `UNLOCK TABLES`.
+ If a session issues a `LOCK TABLES` statement to acquire a lock while already holding locks, its existing locks are released implicitly before the new locks are granted.
+ If a session begins a transaction (for example, with `START TRANSACTION`), an implicit `UNLOCK TABLES` is performed, which causes existing locks to be released.

> Note

> If you use ALTER TABLE on a locked table, it may become unlocked. For example, if you attempt a second ALTER TABLE operation, the result may be an error Table 'tbl_name' was not locked with LOCK TABLES. To handle this, lock the table again prior to the second alteration. See also Section B.5.6.1, “Problems with ALTER TABLE”.
