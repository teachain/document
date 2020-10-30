#### 系统环境：centos7.6

#### 用户：root



#### 1、trust_cli

1、安装依赖

```
yum install autoconf automake libtool

yum install gcc gcc-c++

yum install wget

yum install vim 

yum install -y readline

yum install -y  readline-devel

yum install -y zlib

yum install -y zlib-devel

yum install -y docbook-dtds

yum install -y docbook-style-xsl 

yum install -y fop 

yum install -y libxslt

yum install uuid uuid-devel
```

2、源码编译安装postgresql

```
wget https://ftp.postgresql.org/pub/source/v12.4/postgresql-12.4.tar.gz
tar zxvf postgresql-12.4.tar.gz
cd postgresql-12.4
./configure --prefix=/usr/local/pgsql --with-uuid=ossp
make prefix=/usr/local/pgsql install
cd ..
rm postgresql-12.4.tar.gz
```

3、配置环境变量（把以下内容放置在/etc/profile文件中）

```
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
```

让环境变量生效

```
source /etc/profile
```

4、执行编译

```
cd third && ./build.sh && cd ..

source $PWD/third/source.env

#以下选择其一执行即可
make plpgsql=1

make plpython=1
```

得到动态链接库文件**ldtrust_cli.so**



#### 2、trusted_compute的编译

```
wget https://nodejs.org/dist/v12.19.0/node-v12.19.0-linux-x64.tar.xz

sudo tar  -Jxvf node-v12.19.0-linux-x64.tar.xz -C /usr/local/

sudo ln -s /usr/local/node-v12.19.0-linux-x64/bin/node /usr/local/bin

sudo ln -s /usr/local/node-v12.19.0-linux-x64/bin/npm /usr/local/bin

wget https://golang.google.cn/dl/go1.15.3.linux-amd64.tar.gz

tar -C /usr/local -xzf go1.15.3.linux-amd64.tar.gz

vim /etc/profile

export PATH=$PATH:/usr/local/go/bin

export GOPATH=/root/workspace/go

export PATH=$PATH:$GOPATH/bin

export GOPROXY=https://goproxy.cn,direct

source /etc/profile

#进入clientv2中要进行npm install才可以

#安装go-bindata
go get -u github.com/jteeuwen/go-bindata/...

sudo npm install umi -g

cd trusted_compute

cd clientv2

rm -rf node_modules

npm cache clean --force

npm install

cd ..

bash build
```

将会在api下得到一个**api**可执行文件。



#### 3、upload_plugin

```
yum install wget

yum install vim

yum install zip unzip

yum install git

yum install autoconf automake libtool

yum install gcc gcc-c++

wget https://golang.google.cn/dl/go1.15.3.linux-amd64.tar.gz

tar -C /usr/local -xzvf go1.15.3.linux-amd64.tar.gz

mkdir -p workspace/go/src

vim /etc/profile

export PATH=$PATH:/usr/local/go/bin

export GOPATH=/root/workspace/go

export PATH=$PATH:$GOPATH/bin

export GOPROXY=https://goproxy.cn,direct

source /etc/profile

tar zxvf protobuf-3.0.0-GA.tgz

./autogen.sh

./configure --prefix=/usr/local --enable-shared=no --with-pic

make clean

make -j8

make prefix=/usr/local install

cd plugin_upload

cd ldtrust

bash gen.sh

cd ..

bash make.sh
```

执行以上命令以后，将会在plugin_upload下生成**uploadplugin**可执行文件。



#### 4、trust_server

```
yum install zip unzip

yum install autoconf automake libtool
 
yum install gcc gcc-c++ kernel-devel 

yum install git

yum install bzip2 bzip2-devel bzip2-libs python-devel -y

yum install wget

yum install glibc-static libstdc++-static -y

wget https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.tar.gz

tar zxvf boost_1_74_0.tar.gz

cd boost_1_74_0

./bootstrap.sh

./b2

./b2 install  #默认会安装在/usr/local目录下，分别在lib和include下

cd trust_server

make
```

编译完成以后，在server目录下生成**ldtrust**可执行文件。



####出现错误

```
/usr/bin/ld: cannot find -lpthread
/usr/bin/ld: cannot find -ldl
/usr/bin/ld: cannot find -lrt
/usr/bin/ld: cannot find -lstdc++
/usr/bin/ld: cannot find -lm
/usr/bin/ld: cannot find -lpthread
/usr/bin/ld: cannot find -lc
```

安装

```
yum install glibc-static libstdc++-static -y;
```

即可解决问题。



注意点:

一定要等到出现

```
The Boost C++ Libraries were successfully built!

The following directory should be added to compiler include paths:

    /root/boost_1_74_0

The following directory should be added to linker library paths:

    /root/boost_1_74_0/stage/lib

```

才能确认boost编译完成。

原先一直使用

```
yum install boost

yum install boost-devel

yum install boost-doc
```

这种方式安装boost，就死活不能够编译通过，改为boost源码安装这种方式就解决了这个问题。

postgresql也是这种问题。

源码安装能够解决不少的问题。



#### 他们的关系



trust_cli会调用trust_server中的服务



trust_server会fork upload_plugin的一个进程



upload_plugin则是进行访问simplechain进行上链的



trusted_compute是一个web服务，开发的模型将会部署到pg中



而pg则是会加载trust_cli扩展。