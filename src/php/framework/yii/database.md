## Working with Databases

### Database Access Objects

##### Creating DB Connections

~~~php
$db = new yii\db\Connection([
    'dsn' => 'mysql:host=localhost;dbname=example',
    'username' => 'root',
    'password' => '',
    'charset' => 'utf8',
]);
~~~

configure
~~~php
return [
    // ...
    'components' => [
        // ...
        'db' => [
            'class' => 'yii\db\Connection',
            'dsn' => 'mysql:host=localhost;dbname=example',
            'username' => 'root',
            'password' => '',
            'tablePrefix' => 'tbl_',
            'charset' => 'utf8',
        ],
    ],
    // ...
];
~~~

Sometimes you may want to execute some queries right after the database connection is established to initialize some environment variables (e.g., to set the timezone or character set).
~~~php
'db' => [
    // ...
    'on afterOpen' => function($event) {
        // $event->sender refers to the DB connection
        $event->sender->createCommand("SET time_zone = 'UTC'")->execute();
    }
],
~~~

##### Executing SQL Queries

~~~php
// return a set of rows. each row is an associative array of column names and values.
// an empty array is returned if the query returned no results
$posts = Yii::$app->db->createCommand('SELECT * FROM post')
            ->queryAll();

// return a single row (the first row)
// false is returned if the query has no result
$post = Yii::$app->db->createCommand('SELECT * FROM post WHERE id=1')
           ->queryOne();

// return a single column (the first column)
// an empty array is returned if the query returned no results
$titles = Yii::$app->db->createCommand('SELECT title FROM post')
             ->queryColumn();

// return a scalar value
// false is returned if the query has no result
$count = Yii::$app->db->createCommand('SELECT COUNT(*) FROM post')
             ->queryScalar();
~~~

~~~php
$post = Yii::$app->db->createCommand('SELECT * FROM post WHERE id=:id AND status=:status')
           ->bindValue(':id', $_GET['id'])
           ->bindValue(':status', 1)
           ->queryOne();

$command = Yii::$app->db->createCommand('SELECT * FROM post WHERE id=:id');

$post1 = $command->bindValue(':id', 1)->queryOne();
$post2 = $command->bindValue(':id', 2)->queryOne();

// bindParam(): similar to bindValue() but also support binding parameter references.
$command = Yii::$app->db->createCommand('SELECT * FROM post WHERE id=:id')
              ->bindParam(':id', $id);

$id = 1;
$post1 = $command->queryOne();

$id = 2;
$post2 = $command->queryOne();
~~~

~~~php
Yii::$app->db->createCommand('UPDATE post SET status=1 WHERE id=1')
   ->execute();

// INSERT (table name, column values)
Yii::$app->db->createCommand()->insert('user', [
    'name' => 'Sam',
    'age' => 30,
])->execute();

// UPDATE (table name, column values, condition)
Yii::$app->db->createCommand()->update('user', ['status' => 1], 'age > 30')->execute();

// DELETE (table name, condition)
Yii::$app->db->createCommand()->delete('user', 'status = 0')->execute();

//  insert multiple rows in one shot
Yii::$app->db->createCommand()->batchInsert('user', ['name', 'age'], [
    ['Tom', 30],
    ['Jane', 20],
    ['Linda', 25],
])->execute();
~~~

##### Quoting Table and Column Names

~~~php
// executes this SQL for MySQL: SELECT COUNT(`id`) FROM `employee`
$count = Yii::$app->db->createCommand("SELECT COUNT([[id]]) FROM {{employee}}")
            ->queryScalar();

// executes this SQL for MySQL: SELECT COUNT(`id`) FROM `tbl_employee`
$count = Yii::$app->db->createCommand("SELECT COUNT([[id]]) FROM {{%employee}}")
            ->queryScalar();
~~~

##### Performing Transactions

~~~php
Yii::$app->db->transaction(function($db) {
    $db->createCommand($sql1)->execute();
    $db->createCommand($sql2)->execute();
    // ... executing other SQL statements ...
});
~~~

~~~php
$db = Yii::$app->db;
$transaction = $db->beginTransaction();

try {
    $db->createCommand($sql1)->execute();
    $db->createCommand($sql2)->execute();
    // ... executing other SQL statements ...

    $transaction->commit();

} catch(\Exception $e) {

    $transaction->rollBack();

    throw $e;
}
~~~

Specifying Isolation Levels
~~~php
$isolationLevel = \yii\db\Transaction::REPEATABLE_READ;

Yii::$app->db->transaction(function ($db) {
    ....
}, $isolationLevel);

// or alternatively

$transaction = Yii::$app->db->beginTransaction($isolationLevel);
~~~

Nesting Transactions
~~~php
Yii::$app->db->transaction(function ($db) {
    // outer transaction

    $db->transaction(function ($db) {
        // inner transaction
    });
});
~~~

~~~php
$db = Yii::$app->db;
$outerTransaction = $db->beginTransaction();
try {
    $db->createCommand($sql1)->execute();

    $innerTransaction = $db->beginTransaction();
    try {
        $db->createCommand($sql2)->execute();
        $innerTransaction->commit();
    } catch (\Exception $e) {
        $innerTransaction->rollBack();
        throw $e;
    }

    $outerTransaction->commit();
} catch (\Exception $e) {
    $outerTransaction->rollBack();
    throw $e;
}
~~~

##### Replication and Read-Write Splitting

configure
~~~php
[
    'class' => 'yii\db\Connection',

    // configuration for the master
    'dsn' => 'dsn for master server',
    'username' => 'master',
    'password' => '',

    // common configuration for slaves
    'slaveConfig' => [
        'username' => 'slave',
        'password' => '',
        'attributes' => [
            // use a smaller connection timeout
            PDO::ATTR_TIMEOUT => 10,
        ],
    ],

    // list of slave configurations
    'slaves' => [
        ['dsn' => 'dsn for slave server 1'],
        ['dsn' => 'dsn for slave server 2'],
        ['dsn' => 'dsn for slave server 3'],
        ['dsn' => 'dsn for slave server 4'],
    ],
]
~~~

~~~php
// create a Connection instance using the above configuration
Yii::$app->db = Yii::createObject($config);

// query against one of the slaves
$rows = Yii::$app->db->createCommand('SELECT * FROM user LIMIT 10')->queryAll();

// query against the master
Yii::$app->db->createCommand("UPDATE user SET username='demo' WHERE id=1")->execute();
~~~

configure multiple masters with multiple slaves
~~~php
[
    'class' => 'yii\db\Connection',

    // common configuration for masters
    'masterConfig' => [
        'username' => 'master',
        'password' => '',
        'attributes' => [
            // use a smaller connection timeout
            PDO::ATTR_TIMEOUT => 10,
        ],
    ],

    // list of master configurations
    'masters' => [
        ['dsn' => 'dsn for master server 1'],
        ['dsn' => 'dsn for master server 2'],
    ],

    // common configuration for slaves
    'slaveConfig' => [
        'username' => 'slave',
        'password' => '',
        'attributes' => [
            // use a smaller connection timeout
            PDO::ATTR_TIMEOUT => 10,
        ],
    ],

    // list of slave configurations
    'slaves' => [
        ['dsn' => 'dsn for slave server 1'],
        ['dsn' => 'dsn for slave server 2'],
        ['dsn' => 'dsn for slave server 3'],
        ['dsn' => 'dsn for slave server 4'],
    ],
]
~~~
By default, transactions use the master connection. And within a transaction, all DB operations will use the master connection.

##### Working with Database Schema

+ createTable(): creating a table
+ renameTable(): renaming a table
+ dropTable(): removing a table
+ truncateTable(): removing all rows in a table
+ addColumn(): adding a column
+ renameColumn(): renaming a column
+ dropColumn(): removing a column
+ alterColumn(): altering a column
+ addPrimaryKey(): adding a primary key
+ dropPrimaryKey(): removing a primary key
+ addForeignKey(): adding a foreign key
+ dropForeignKey(): removing a foreign key
+ createIndex(): creating an index
+ dropIndex(): removing an index

~~~php
// CREATE TABLE
Yii::$app->db->createCommand()->createTable('post', [
    'id' => 'pk',
    'title' => 'string',
    'text' => 'text',
]);

$table = Yii::$app->db->getTableSchema('post');
~~~

### Query Builder

~~~php
$rows = (new \yii\db\Query())
    ->select(['id', 'email'])
    ->from('user')
    ->where(['last_name' => 'Smith'])
    ->limit(10)
    ->all();
~~~

##### Building Queries

select()
~~~php
$query->select(['user.id AS user_id', 'email']);

// equivalent to:

$query->select('user.id AS user_id, email');
$query->select(['user_id' => 'user.id', 'email']);

$query->select(["CONCAT(first_name, ' ', last_name) AS full_name", 'email']);

// Starting from version 2.0.1, you may also select sub-queries.
$subQuery = (new Query())->select('COUNT(*)')->from('user');

// SELECT `id`, (SELECT COUNT(*) FROM `user`) AS `count` FROM `post`
$query = (new Query())->select(['id', 'count' => $subQuery])->from('post');
~~~

from()
~~~php
// SELECT * FROM `user`
$query->from('user');

$query->from(['public.user u', 'public.post p']);

// equivalent to:

$query->from('public.user u, public.post p');
$query->from(['u' => 'public.user', 'p' => 'public.post']);

// Besides table names, you can also select from sub-queries by specifying them in terms of yii\db\Query objects.
$subQuery = (new Query())->select('id')->from('user')->where('status=1');

// SELECT * FROM (SELECT `id` FROM `user` WHERE status=1) u
$query->from(['u' => $subQuery]);
~~~

where()
+ string format, e.g., 'status=1'
+ hash format, e.g. ['status' => 1, 'type' => 2]
+ operator format, e.g. ['like', 'name', 'test']
~~~php
$query->where('status=1');

// or use parameter binding to bind dynamic parameter values
$query->where('status=:status', [':status' => $status]);

// raw SQL using MySQL YEAR() function on a date field
$query->where('YEAR(somedate) = 2015');

$query->where('status=:status')
    ->addParams([':status' => $status]);


// ...WHERE (`status` = 10) AND (`type` IS NULL) AND (`id` IN (4, 8, 15))
$query->where([
    'status' => 10,
    'type' => null,
    'id' => [4, 8, 15],
]);

$userQuery = (new Query())->select('id')->from('user');

// ...WHERE `id` IN (SELECT `id` FROM `user`)
$query->where(['id' => $userQuery]);

$status = 10;
$search = 'yii';

$query->where(['status' => $status]);

if (!empty($search)) {
    $query->andWhere(['like', 'title', $search]);
}

// $username and $email are from user inputs
$query->filterWhere([
    'username' => $username,
    'email' => $email,
]);
~~~

Operator Format
+ ['and', 'id=1', 'id=2']
+ ['between', 'id', 1, 10]
+ ['in', 'id', [1, 2, 3]]
+ ['like', 'name', ['test', 'sample']]

orderBy() groupBy() having() limit() and offset()
~~~php
// ... ORDER BY `id` ASC, `name` DESC
$query->orderBy([
    'id' => SORT_ASC,
    'name' => SORT_DESC,
]);

// ... GROUP BY `id`, `status`
$query->groupBy(['id', 'status']);

$query->groupBy(['id', 'status'])
    ->addGroupBy('age');

// ... HAVING (`status` = 1) AND (`age` > 30)
$query->having(['status' => 1])
    ->andHaving(['>', 'age', 30]);

// ... LIMIT 10 OFFSET 20
$query->limit(10)->offset(20);
~~~

join() union()
~~~php
$query->join('LEFT JOIN', 'post', 'post.user_id = user.id');
$query->leftJoin('post', 'post.user_id = user.id');

$query1 = (new \yii\db\Query())
    ->select("id, category_id AS type, name")
    ->from('post')
    ->limit(10);

$query2 = (new \yii\db\Query())
    ->select('id, type, name')
    ->from('user')
    ->limit(10);

$query1->union($query2);
~~~

##### Query Methods

+ all(): returns an array of rows with each row being an associative array of name-value pairs.
+ one(): returns the first row of the result.
+ column(): returns the first column of the result.
+ scalar(): returns a scalar value located at the first row and first column of the result.
+ exists(): returns a value indicating whether the query contains any result.
+ count(): returns the result of a COUNT query.

~~~php
// SELECT `id`, `email` FROM `user`
$rows = (new \yii\db\Query())
    ->select(['id', 'email'])
    ->from('user')
    ->all();

// SELECT * FROM `user` WHERE `username` LIKE `%test%`
$row = (new \yii\db\Query())
    ->from('user')
    ->where(['like', 'username', 'test'])
    ->one();

// executes SQL: SELECT COUNT(*) FROM `user` WHERE `last_name`=:last_name
$count = (new \yii\db\Query())
    ->from('user')
    ->where(['last_name' => 'Smith'])
    ->count();

$command = (new \yii\db\Query())
    ->select(['id', 'email'])
    ->from('user')
    ->where(['last_name' => 'Smith'])
    ->limit(10)
    ->createCommand();

// show the SQL statement
echo $command->sql;
// show the parameters to be bound
print_r($command->params);

// returns all rows of the query result
$rows = $command->queryAll();

// returns [100 => ['id' => 100, 'username' => '...', ...], 101 => [...], 103 => [...], ...]
$query = (new \yii\db\Query())
    ->from('user')
    ->limit(10)
    ->indexBy('id')
    ->all();

$query = (new \yii\db\Query())
    ->from('user')
    ->indexBy(function ($row) {
        return $row['id'] . $row['username'];
    })->all();
~~~

### Active Record

### Database Migration