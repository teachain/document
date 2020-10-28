



```
wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm

rpm -ivh mysql-community-release-el7-5.noarch.rpm

yum install mysql-community-server
```



安装成功后重启mysql服务。

```
# service mysqld restart
```

初次安装mysql，root账户没有密码。

```
 mysql -u root 
```

设置密码

```
set password for 'root'@'localhost' =password('root');
```

分配权限,格式为

```
grant all privileges on *.* to root@'%'identified by 'password';
```

我们测试，我们就简单设置,生产服务器禁止这么操作。

```
grant all privileges on *.* to root@'%'identified by 'root';
```

创建用户

```
create user 'username'@'%' identified by 'password';  
```



我们的测试用例



```
create user 'usr_kenyon'@'%' identified by 'usr_kenyon123456';  

create database db_kenyon;

use db_kenyon;

CREATE TABLE warehouse ( 
		warehouse_id int auto_increment primary key,
		warehouse_name text,
		warehouse_created timestamp 
	);

select * from tbl_kenyon;

grant all privileges on db_kenyon.tbl_kenyon to 'usr_kenyon'@'%' identified by 'usr_kenyon123456';

flush privileges;

--localhost登录
grant all privileges on *.* to 'usr_kenyon'@'localhost' identified by 'usr_kenyon123456';

flush privileges;

alter table tb_name modify id int auto_increment primary key
```

