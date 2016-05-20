## [13.3.7 XA Transactions](http://dev.mysql.com/doc/refman/5.6/en/xa.html)

+ [XA Transaction SQL Syntax](./7/xa-statements.md)
+ [XA Transaction States](./7/xa-states.md)

InnoDB 支持[XA](http://dev.mysql.com/doc/refman/5.6/en/glossary.html#glos_xa)事务。

The MySQL XA implementation is based on the X/Open CAE document *Distributed Transaction Processing: The XA Specification*. Limitations of the current XA implementation are described in [Section C.6, “Restrictions on XA Transactions”](http://dev.mysql.com/doc/refman/5.6/en/xa-restrictions.html).

MySQL客户端没有特殊需求。MySQL Connector/J 5.0.0 and higher supports XA directly。

XA支持分布式事务。

一些分布式事务的例子：

+ 作为集成工具，使用RDBMS的消息服务应用。
+ 使用不同数据库服务器的应用。
+ 银行。

Applications that use global transactions involve one or more Resource Managers and a Transaction Manager:

+ A Resource Manager (RM)
+ A Transaction Manager (TM)

The process for executing a global transaction uses two-phase commit (2PC). This takes place after the actions performed by the branches of the global transaction have been executed.

1. In the first phase, all branches are prepared. That is, they are told by the TM to get ready to commit. Typically, this means each RM that manages a branch records the actions for the branch in stable storage. The branches indicate whether they are able to do this, and these results are used for the second phase.

2. In the second phase, the TM tells the RMs whether to commit or roll back. If all branches indicated when they were prepared that they will be able to commit, all branches are told to commit. If any branch indicated when it was prepared that it will not be able to commit, all branches are told to roll back.

