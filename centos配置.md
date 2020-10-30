先配置网络

```
#物理机中配置
vi /etc/sysconfig/network-scripts/ifcfg-eth0

#虚拟机中配置
vi /etc/sysconfig/network-scripts/ifcfg-eth33
```

开机即可获取ip地址的配置

```
ONBOOT=yes
BOOTPROTO=dhcp
```

让配置生效

```
service network restart
#或者
systemctl restart network
#或者
/etc/init.d/network restart
```



#### 关于BOOTPROTO

它的取值可以是以下这些值：

* none,禁止DHCP
* static,启用静态IP地址
* dhcp,开启DHCP服务

当设置为static时，则需要配置以下内容,取值都根据自己的环境。

```
BOOTPROTO=static
IPADDR=192.168.1.200
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=192.168.1.1
DNS2=202.96.128.86
```

#### ifconfig

要想能够使用ifconfig命令，则需要安装net-tools

```
[sudo] yum install net-tools
```

#### DNS

配置dns

```
[sudo] vi /etc/resolv.conf

nameserver 202.96.128.86
```

使用yum进行查找

```
yum search ifconfig #查找ifconfig
```

安装zip

```
yum install zip unzip
```

