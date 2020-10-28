我们在上文中已经安装好了postgresql这一款数据库管理系统。

这一节我们来对postgresql进行初始化和使用。

我们为postgresql创建一个用户。

```
#创建一个名为postgres的用户组 
groupadd postgres

#创建一个用户名为postgres的用户并将用户加入到名为postgres的用户组中
useradd -g postgres postgres

#给用户名为postgres的用户设置密码
passwd postgres

1q2w3e4r #至少8位

```

这样我们就创建了一个用户名以及设置了对应的密码。

将pg的数据目录全部赋给postgres用户

```
#切换到postgres用户

su - postgres

#创建目录
mkdir pgsql

#初始化数据库
initdb -D /home/postgres/pgsql -U postgres --locale=en_US.UTF8 -E UTF8
```

我们从最后一个命令的输出中，我们得到启动命令。

```
pg_ctl -D /home/postgres/pgsql -l logfile start
```

我们也顺便看一下，刚才初始化的命令给我们生成了一些什么东西。

```
ls ~/pgsql/
```

从输出中，我们看到命令给我们生成了以下的一些目录和文件，我们比较关注postgresql.conf这个文件。

```
base          pg_hba.conf    pg_notify     pg_stat      pg_twophase  postgresql.auto.conf
global        pg_ident.conf  pg_replslot   pg_stat_tmp  PG_VERSION   postgresql.conf
pg_commit_ts  pg_logical     pg_serial     pg_subtrans  pg_wal
pg_dynshmem   pg_multixact   pg_snapshots  pg_tblspc    pg_xact
```

其中

* base 目录是表空间目录
* global目录是相关全局变量目录
* pg_hba.conf是访问控制配置文件
* postgresql.conf是postgresql的主配置文件

```


mkdir ~/pgsql/log
cd ~/pgsql/log
touch logfile
```





#### 启动数据库

```
pg_ctl -D /home/postgres/pgsql -l /home/postgres/pgsql/log/logfile start
```

#### 停止数据库

```
pg_ctl -D /home/postgres/pgsql -s -m fast stop
```



直接在终端输入以下命令

```
psql
```

即可直接进入postgresql。（第一次）

```
[postgres@localhost ~]$ psql
psql (12.4)
Type "help" for help.

postgres=# 
```

我们在psql的提示符下,分别输入以下命令来查看一下系统的情况。

```
select * from pg_user;

select * from pg_roles;

select * from information_schema.table_privileges where grantee='cc';
```

为postgres用户设置数据库系统的密码,在psql的提示符下

```
ALTER USER postgres WITH encrypted PASSWORD 'qq123456';
```



```
vim /home/postgres/pgsql/postgresql.conf
```

修改认证方式

```
vim /home/postgres/pgsql/pg_hba.conf
```

再次登录

```
psql -h localhost -p 5432 -U postgres
```

