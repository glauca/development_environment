## [4.7 Using MySQL with Apache](http://dev.mysql.com/doc/refman/5.7/en/apache.html)

You can change the Apache logging format to be easily readable by MySQL by putting the following into the Apache configuration file:

~~~bash
LogFormat \
        "\"%h\",%{%Y%m%d%H%M%S}t,%>s,\"%b\",\"%{Content-Type}o\",  \
        \"%U\",\"%{Referer}i\",\"%{User-Agent}i\""
~~~

To load a log file in that format into MySQL, you can use a statement something like this:

~~~bash
LOAD DATA INFILE '/local/access_log' INTO TABLE tbl_name
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '\\'
~~~