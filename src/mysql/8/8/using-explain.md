## [8.8.1 Optimizing Queries with EXPLAIN](http://dev.mysql.com/doc/refman/5.6/en/using-explain.html)

+ As of MySQL 5.6.3，允许 `EXPLAIN` 的语句有 `SELECT`, `DELETE`, `INSERT`, `REPLACE`, and `UPDATE`
+ [`EXPLAIN EXTENDED`](http://dev.mysql.com/doc/refman/5.6/en/explain-extended.html)
+ [`EXPLAIN PARTITIONS`](http://dev.mysql.com/doc/refman/5.6/en/explain.html) [See Section 19.3.5, “Obtaining Information About Partitions”](http://dev.mysql.com/doc/refman/5.6/en/partitioning-info.html)
+ As of MySQL 5.6.3, the `FORMAT` option can be used to select the output format. `TRADITIONAL` presents the output in tabular format. This is the default if no `FORMAT` option is present. `JSON` format displays the information in `JSON` format. With `FORMAT = JSON`, the output includes extended and partition information.