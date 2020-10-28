####1、创建扩展

（我们需要在postgres用户下，postgres它是超级用户）

mysql_fdw为扩展名

```
psql

postgres=# create extension mysql_fdw;
```

#### 2、创建server映射

mysql_server为server名，mysql_fdw为扩展名

```
postgres=# CREATE SERVER mysql_server FOREIGN DATA WRAPPER mysql_fdw OPTIONS (host '127.0.0.1', port '3306');
```

注意两点：

* host 为mysql的主机ip
* post为mysql的监听端口

#### 3、创建用户映射

postgres为用户名，mysql_server为server名

```
postgres=# CREATE USER MAPPING FOR postgres SERVER mysql_server OPTIONS (username 'usr_kenyon', password 'usr_kenyon123456');
```

注意两点：

* username为mysql的用户名
* password为mysql的用户的密码

#### 4、创建外部表

warehouse为外部表名，mysql_server为server名

```
postgres=# CREATE FOREIGN TABLE warehouse ( warehouse_id int,warehouse_name text,warehouse_created timestamp) SERVER mysql_server OPTIONS (dbname 'db_kenyon', table_name 'warehouse');
```

注意两点：

* dbname为mysql 库的数据库名
* table_name为mysql库里定义的数据表名

#### 5、插入一些数据进行测试，并查看。

````
postgres=# INSERT INTO warehouse values (1, 'UPS', current_date);
postgres=# INSERT INTO warehouse values (2, 'TV', current_date);
postgres=# INSERT INTO warehouse values (3, 'Table', current_date);

postgres=# SELECT * FROM warehouse ORDER BY 1;
````

#### 6、删除表

warehouse为外部表名

```
postgres=# drop foreign table warehouse; 
```

#### 7、删除用户映射

mysql_server为server名,postgres为用户名

```
postgres=# drop user mapping for postgres server mysql_server ;
```

#### 8、删除server

mysql_server为server名

```
postgres=# drop server mysql_server ;
```

#### 9、删除扩展

mysql_fdw为扩展名

```
postgres=# drop extension mysql_fdw ;
```