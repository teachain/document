### postgresql通过mysql_fdw访问mysql数据库

PostgreSQL 读作 Post-Gres-Q-L

#### 1、安装依赖环境

```
yum install wget

yum install vim 

yum install docbook-dtds docbook-style-xsl fop libxslt 

yum install -y gcc gcc-c++  epel-release llvm5.0 llvm5.0-devel clang libicu-devel perl-ExtUtils-Embed readline readline-devel zlib zlib-devel openssl openssl-devel pam-devel libxml2-devel libxslt-devel openldap-devel systemd-devel tcl-devel python-devel

yum install mysql-devel
```

#### 2、源码安装postgresql

```
wget https://ftp.postgresql.org/pub/source/v12.4/postgresql-12.4.tar.gz

tar zxvf postgresql-12.4.tar.gz

cd postgresql-12.4

./configure --prefix=/usr/local/pgsql

make prefix=/usr/local/pgsql install
```

配置环境变量

```
vim /etc/profile

#添加内容如下：
export PGHOME=/usr/local/pgsql

export PATH=$PGHOME/bin:$PATH

PGHOME="/usr/local/pgsql"
if [ -z "${PATH}" ];then
    export PATH="${PGHOME}/bin"
else
    export PATH="${PGHOME}/bin:${PATH}"
fi
if [ -z "${C_INCLUDE_PATH}" ];then
    export C_INCLUDE_PATH="${PGHOME}/include"
else
    export C_INCLUDE_PATH="${PGHOME}/include:${C_INCLUDE_PATH}"
fi
if [ -z "${CPLUS_INCLUDE_PATH}" ];then
    export CPLUS_INCLUDE_PATH="${PGHOME}/include"
else
    export CPLUS_INCLUDE_PATH="${PGHOME}/include:${CPLUS_INCLUDE_PATH}"
fi
if [ -z "${LD_LIBRARY_PATH}" ];then
    export LD_LIBRARY_PATH="${PGHOME}/lib"
else
    export LD_LIBRARY_PATH="${PGHOME}/lib:${LD_LIBRARY_PATH}"
fi
if [ -z "${LIBRARY_PATH}" ];then
    export LIBRARY_PATH="${PGHOME}/lib"
else
    export LIBRARY_PATH="${PGHOME}/lib:${LIBRARY_PATH}"
fi

#使配置的环境变量生效
source /etc/profile
```

#### 3、下载mysql_fdw源码，并编译安装在postgresql所在的服务器上

```
git clone https://github.com/EnterpriseDB/mysql_fdw.git
cd mysql_fdw
make USE_PGXS=1
make USE_PGXS=1 install
```

这样通过日志的输出，我们看到

```
/usr/bin/mkdir -p '/usr/local/pgsql/lib'
/usr/bin/mkdir -p '/usr/local/pgsql/share/extension'
/usr/bin/mkdir -p '/usr/local/pgsql/share/extension'
/usr/bin/install -c -m 755  mysql_fdw.so '/usr/local/pgsql/lib/mysql_fdw.so'
/usr/bin/install -c -m 644 .//mysql_fdw.control '/usr/local/pgsql/share/extension/'
/usr/bin/install -c -m 644 .//mysql_fdw--1.0.sql .//mysql_fdw--1.1.sql .//mysql_fdw--1.0--1.1.sql  '/usr/local/pgsql/share/extension/'

```

mysql_fdw.so和mysql_fdw.control以及mysql_fdw--1.1.sql都安装到了对应的位置上。

#### 碰到的问题

在编译mysql_fdw的过程中，也就是make USE_PGXS=1的过程中，出现了

```
Makefile:52: *** PostgreSQL 9.3, 9.4, 9.5 or 9.6 is required to compile this extension.  Stop.
```

我们用vim打开了Makefile文件，并查看52行的内容,我们往上一行看

```
51 ifeq (,$(findstring $(MAJORVERSION), 9.3 9.4 9.5 9.6))
52 $(error PostgreSQL 9.3, 9.4, 9.5 or 9.6 is required to compile this extension)
```

ifeq (,$(findstring $(MAJORVERSION), 9.3 9.4 9.5 9.6))，也就是说它适合的版本是9.3 9.4 9.5 9.6这几个版本。

我原来一直没有仔细看这一行内容，浪费了自己不少的时间，这是需要吸取的教训。我这是从它的官网上下载的

mysql_fdw-2.1.2版本，我以为就是最新的了。后来从一些博客中了解到github.com上有源码。故从上面直接克

隆，从而解决了这个问题，也才仔细理解了Makefile的提示。



#### github.com上的方法

```
export PATH=/usr/local/pgsql/bin/:$PATH

export PATH=/usr/local/mysql/bin/:$PATH

make USE_PGXS=1

make USE_PGXS=1 install
```

就简单的4条命令就解决了。根据提示，缺啥补啥就可以了。

