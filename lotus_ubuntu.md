必须先安装的依赖：

ubuntu 16.04

```
sudo apt-get install autoconf automake libtool

sudo apt-get install postgresql-server-dev-13

sudo apt-get install libssl-dev

sudo apt-get install libkrb5-dev
```

##### trust_cli

##### 命令

在trust_cli目录下，执行以下命令：

```
cd third && ./build.sh && cd ..
source $PWD/third/source.env
```

主要的工作是安装protobuf和grpc,以及配置以下环境变量

```
export PATH
export LIBRARY_PATH
export C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH
export PKG_CONFIG_PATH
export TOOLCHAIN_INS
```

protobuf和grpc都安装到third/installed目录下。



plugin_upload的编译

在这之前要配置好go的bin目录到PATH环境变量上以及$GOPATH/bin配置到PATH

必须首先将$GOPATH/bin路径添加到环境变量$PATH中

```
git clone https://github.com/golang/protobuf.git

cd protobuf/protoc-gen-go

go install
```

```
cd ldtrust
bash gen.sh
cd ..
bash make.sh
```



#### trusted_compute的编译

```
wget https://nodejs.org/dist/v12.19.0/node-v12.19.0-linux-x64.tar.xz

sudo tar  -Jxvf node-v12.19.0-linux-x64.tar.xz -C /usr/local/

sudo ln -s /usr/local/node-v12.19.0-linux-x64/bin/node /usr/local/bin

sudo ln -s /usr/local/node-v12.19.0-linux-x64/bin/npm /usr/local/bin

#进入clientv2中要进行npm install才可以

#安装go-bindata
go get -u github.com/jteeuwen/go-bindata/...

sudo npm install umi -g

rm -rf node_modules

npm cache clean --force

npm install

cd trusted_compute
```

#### **trust_server**的编译

sudo dpkg-reconfigure dash

在界面中选择no

然后再次确认

```
ls -l `which sh`
```

必须是

```
/bin/sh -> bash
```

因为make中它使用了source命令，所以请确认系统的sh是bash才可以。



```
sudo apt-get install libboost-all-dev

apt-get install build-essential autoconf libtool pkg-config
```





```
wget https://openssl.org/source/openssl-1.0.2k.tar.gz --no-check-certificate
tar zxvf openssl-1.0.2k.tar.gz 
cd openssl-1.0.2k/
./config shared --prefix=/usr/local/
sudo make install
sudo cp libcrypto.so.1.0.0 /usr/lib/x86_64-linux-gnu/
sudo cp libssl.so.1.0.0 /usr/lib/x86_64-linux-gnu/
rm /usr/bin/openssl
sudo ln -s /usr/local/bin/openssl /usr/bin/openssl
openssl version
```





```

 sudo apt-get install pkg-config
 
 sudo apt-get install autoconf automake libtool make g++ unzip

 sudo apt-get install libgflags-dev libgtest-dev

 sudo apt-get install clang libc++-dev

sudo apt-get install libffi-dev
```



环境变量

```
LIBRARY_PATH
LD_LIBRARY_PATH
C_INCLUDE_PATH
CPLUS_INCLUDE_PATH
PKG_CONFIG_PATH
```







```
./stress --sendtx --chainid=10388 --url='ws://192.168.4.115:8546' \
--sendkey='5aedb85503128685e4f92b0cc95e9e1185db99339f9b85125c1e2ddc0f7c4c48' \
--threads=3  \
--seed=2612 \
--tps=1600
```





```\
--chainid=10388 --url='ws://120.237.88.120:8546' \
--sendkey='5aedb85503128685e4f92b0cc95e9e1185db99339f9b85125c1e2ddc0f7c4c48' \
--threads=3  \
--seed=2612 \
--tps=1600

./client --chainid=10388 --url='ws://192.168.4.116:8546' \
--sendkey='5aedb85503128685e4f92b0cc95e9e1185db99339f9b85125c1e2ddc0f7c4c48' \
--threads=8  \
--seed=2612 \
--tps=1600 \
-proxy_url=ws://127.0.0.1:8548

./proxy -sipe_url=ws://192.168.4.116:8546
```

