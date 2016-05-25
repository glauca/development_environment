## [XA Transaction States](http://dev.mysql.com/doc/refman/5.6/en/xa-states.html)

An XA transaction progresses through the following states:

+ Use `XA START` to start an XA transaction and put it in the `ACTIVE` state.
+ For an `ACTIVE` XA transaction, issue the SQL statements that make up the transaction, and then issue an `XA END` statement. `XA END` puts the transaction in the `IDLE` state.
+ For an `IDLE` XA transaction, you can issue either an `XA PREPARE` statement or an `XA COMMIT ... ONE PHASE` statement:
    + `XA PREPARE` puts the transaction in the PREPARED state. An `XA RECOVER` statement at this point will include the transaction's *xid* value in its output, because `XA RECOVER` lists all XA transactions that are in the `PREPARED` state.
    + `XA COMMIT ... ONE PHASE` prepares and commits the transaction. The xid value will not be listed by `XA RECOVER` because the transaction terminates.
+ For a `PREPARED` XA transaction, you can issue an `XA COMMIT` statement to commit and terminate the transaction, or `XA ROLLBACK` to roll back and terminate the transaction.

~~~mysql
mysql> XA START 'xatest';
Query OK, 0 rows affected (0.00 sec)

mysql> INSERT INTO mytable (i) VALUES(10);
Query OK, 1 row affected (0.04 sec)

mysql> XA END 'xatest';
Query OK, 0 rows affected (0.00 sec)

mysql> XA PREPARE 'xatest';
Query OK, 0 rows affected (0.00 sec)

mysql> XA COMMIT 'xatest';
Query OK, 0 rows affected (0.00 sec)
~~~