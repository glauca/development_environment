## [XA Transaction SQL Syntax](http://dev.mysql.com/doc/refman/5.6/en/xa-statements.html)

~~~mysql
XA {START|BEGIN} xid [JOIN|RESUME]

XA END xid [SUSPEND [FOR MIGRATE]]

XA PREPARE xid

XA COMMIT xid [ONE PHASE]

XA ROLLBACK xid

XA RECOVER
~~~

> For XA START, the JOIN and RESUME clauses are not supported.

> For XA END the SUSPEND [FOR MIGRATE] clause is not supported.

Each XA statement **begins with the *XA* keyword**, and most of them **require an *xid* value**.

~~~
xid: gtrid [, bqual [, formatID ]]
~~~

+ gtrid 是全局的事务标识，bqual 是分支修饰词，formatID 是一个数字用来标识 gtrid 和 bqual 的格式。bqual and formatID 是可选的。 bqual 的默认值是 ''，formatID 的默认值是1。
+ gtrid and bqual 必须是字符串，64字节。gtrid and bqual 可以用多种方式定义，如quoted string ('ab'), hex string (X'6162', 0x6162), or bit value (b'nnnn')。
+ formatID is an unsigned integer.

To be safe, write gtrid and bqual as hex strings.

XA RECOVER output rows look like this (for an example xid value consisting of the parts 'abc', 'def', and 7):

~~~mysql
mysql> XA RECOVER;
+----------+--------------+--------------+--------+
| formatID | gtrid_length | bqual_length | data   |
+----------+--------------+--------------+--------+
|        7 |            3 |            3 | abcdef |
+----------+--------------+--------------+--------+
~~~

+    formatID is the formatID part of the transaction xid
+    gtrid_length is the length in bytes of the gtrid part of the xid
+    bqual_length is the length in bytes of the bqual part of the xid
+    data is the concatenation of the gtrid and bqual parts of the xid