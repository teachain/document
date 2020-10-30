#### database 和schema以及table的关系

从逻辑上看，schema，table，都是位于database之下。

```
SELECT * FROM information_schema.tables WHERE table_name='your_table_name';
```

在pgsql命令行下，查看一下它的基本结构

```
postgres=#\d information_schema.tables
```

输入以上内容，将会得到以下的输出

```
                                 View "information_schema.tables"
            Column            |               Type                | Collation | Nullable | Default 
------------------------------+-----------------------------------+-----------+----------+---------
 table_catalog                | information_schema.sql_identifier |           |          | 
 table_schema                 | information_schema.sql_identifier |           |          | 
 table_name                   | information_schema.sql_identifier |           |          | 
 table_type                   | information_schema.character_data |           |          | 
 self_referencing_column_name | information_schema.sql_identifier |           |          | 
 reference_generation         | information_schema.character_data |           |          | 
 user_defined_type_catalog    | information_schema.sql_identifier |           |          | 
 user_defined_type_schema     | information_schema.sql_identifier |           |          | 
 user_defined_type_name       | information_schema.sql_identifier |           |          | 
 is_insertable_into           | information_schema.yes_or_no      |           |          | 
 is_typed                     | information_schema.yes_or_no      |           |          | 
 commit_action                | information_schema.character_data |           |          | 

```



#### 模式

PostgreSQL 模式（SCHEMA）可以看做是一个表的集合

一个模式可以包含视图、索引、据类型、函数和操作符等。

相同的对象名称可以被用于不同的模式中而不会出现冲突，例如 schema1 和 myschema 都可以包含名为 mytable 的表。

使用模式的优势：

- **允许多个用户使用一个数据库并且不会互相干扰**。
- 将数据库对象组织成逻辑组以便更容易管理。
- **第三方应用的对象可以放在独立的模式中，这样它们就不会与其他对象的名称发生冲突**。



#### 每个 database 创建好后，默认会有3个Schema。

- 一个名为**pg_catalog**，用于存储Postgresql系统自带的函数,表,系统视图,数据类型转换器以及数据类型定义等元数据
- 一个名为**information_schema**，用于存储所需求提供的元数据查询视图,目的是以符合ANSI SQL规范,可单独删除
- 一个名为**public**，用于存储用户创建的数据表。不建议项目的表存放在public下，1、是数据安全；2、表存放混乱；不利于后期维护等等

##### 创建模式

```
CREATE SCHEMA schema_name;
```

#### 删除模式

删除空模式

```
DROP SCHEMA schema_name;
```

删除一个模式以及其中包含的所有对象:

```
DROP SCHEMA schema_name CASCADE;
```



一个实例下有多个数据库；每个数据库之间是完全独立的。

数据库下面有多个Schema；其中“public” 是数据库创建时产生的。

每个Schema下面可以创建表，视图，索引，函数，序列，物化视图，外部表等等。



#### 系统表pg_database可以查到数据库

```
select * from pg_database;
select datname, oid from pg_database where datname = 'postgres';
```

#### 通过系统表pg_class可以查到数据库object

```

```

**和数据库不同，模式不是严格分离的：只要有权限，一个用户可以访问他所连接的数据库中的任意模式中的对象**。





- SQL函数包体是一些可执行的SQL语言。同时包含1条以上的查询，但是函数只返回最后一个查询(必须是SELECT)的结果。
- 除非SQL函数声明为返回void，否则最后一条语句必须是SELECT
- 在简单情况下，返回最后一条查询结果的第一行。
- 如果最后一个查询不返回任何行，那么该函数将返回NULL值。
- 如果需要该函数返回最后一条SELECT语句的所有行，可以将函数的返回值定义为集合，即SETOF sometype。

PL/pgSQL是一个块结构语言。函数定义的所有文本都必须是一个块。一个块用下面的方法定义：
　　PL/pgSQL程序由三个部分组成，即声明部分、执行部分、异常处理部分。
　　PL/pgSQL的结构如下：



```
DECLARE 
   --声明部分: 在此声明PL/SQL用到的变量,类型及游标.
 BEGIN
   -- 执行部分:  过程及SQL语句,即程序的主要部分
 EXCEPTION
   -- 执行异常部分: 错误处理
 END;
```



在PostgreSQL中可以利用RAISE语句报告信息和抛出错误，其声明形式为：



```
RAISE level 'format' [, expression [, ...]];
```