## 13.3.4 SAVEPOINT, ROLLBACK TO SAVEPOINT, and RELEASE SAVEPOINT Syntax

~~~mysql
SAVEPOINT identifier
ROLLBACK [WORK] TO [SAVEPOINT] identifier
RELEASE SAVEPOINT identifier
~~~

InnoDB支持 `SAVEPOINT`, `ROLLBACK TO SAVEPOINT`, `RELEASE SAVEPOINT` 和可选的 `ROLLBACK` 关键字 `WORK`。

`SAVEPOINT` 为事务设置一个保存点。如果当前的保存点和之前的一样，那么老的保存点会被删除。
`ROLLBACK TO SAVEPOINT` 会回滚事务到保存点而不会退出事务。后续的保存点会被删除。

~~~mysql
ERROR 1305 (42000): SAVEPOINT identifier does not exist
~~~

`RELEASE SAVEPOINT` 释放一个保存点。

当执行了 `COMMIT`, or a `ROLLBACK` 当前事务的所有保存点会被删除。
