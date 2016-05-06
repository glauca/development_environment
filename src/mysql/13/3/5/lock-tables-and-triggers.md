### [13.3.5.2 LOCK TABLES and Triggers](http://dev.mysql.com/doc/refman/5.6/en/lock-tables-and-triggers.html)

如果显式的锁了一个表，那么触发器使用的任何表也会被隐式锁住。

+ 在使用 `LOCK TABLES` 语句显式的获得锁的时候，这些表的锁也生效了。
+ 触发器中锁掉的表如果获得的是一个读锁，那么读锁将生效，否则是写锁。
+ 如果触发器需要修改数据，而表是显示的获得读锁，那么隐式获得一个写锁而不是读锁。

Suppose that you lock two tables, t1 and t2, using this statement:

~~~mysql
LOCK TABLES t1 WRITE, t2 READ;
~~~

If t1 or t2 have any triggers, tables used within the triggers will also be locked. Suppose that t1 has a trigger defined like this:

~~~mysql
CREATE TRIGGER t1_a_ins AFTER INSERT ON t1 FOR EACH ROW
BEGIN
  UPDATE t4 SET count = count+1
      WHERE id = NEW.id AND EXISTS (SELECT a FROM t3);
  INSERT INTO t2 VALUES(1, 2);
END;
~~~

The result of the LOCK TABLES statement is that t1 and t2 are locked because they appear in the statement, and t3 and t4 are locked because they are used within the trigger:

+ t1 is locked for writing per the WRITE lock request.
+ t2 is locked for writing, even though the request is for a READ lock. This occurs because t2 is inserted into within the trigger, so the READ request is converted to a WRITE request.
+ t3 is locked for reading because it is only read from within the trigger.
+ t4 is locked for writing because it might be updated within the trigger.