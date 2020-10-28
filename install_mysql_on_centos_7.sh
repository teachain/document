#!/bin/bash
#install mysql.
echo y | yum install mysql
if [  $? -ne  0 ];then
echo "yum install mysql failed"
exit 1
fi


#download mysql-server
wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
if [ $? -ne 0 ];then
    echo "wget is not installed"
    yum -y install wget
    wget http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm
    if [ $? -ne 0 ];then
      echo "download mysql-server failed."
      exit 1
    fi
fi




#install mysql-server
rpm -ivh mysql-community-release-el7-5.noarch.rpm
if [ $? -ne 0 ];then
    echo "rpm -ivh mysql-community-release-el7-5.noarch.rpm failed"
    exit 1
fi
#install mysql-community-server
yum install -y mysql-community-server
if [ $? -ne 0 ];then
    echo "rpm -ivh mysql-community-server failed"
    exit 1
fi


#install mysql-devel
yum -y install mysql-devel
if [ $? -ne 0 ];then
    echo "yum install mysql-devel failed"
    exit 1
fi

#set character-set in /etc/my.cnf
if [ ! -f "/etc/my.cnf" ];then
    echo "/etc/my.cnf doesn't exists. set character-set failed."
    exit 1
fi
echo "[mysql]">> /etc/my.cnf
echo "default-character-set =utf8">> /etc/my.cnf


#restart mysql 
service mysqld restart
if [ $? -ne 0 ];then
    echo "service mysqld restart failed."
    exit 1
fi


# execute sql modify password to root  
#grant all table permission to root user in any IP.

echo -e "\n" | mysql -u root -p -e "  
USE mysql;
grant all privileges on *.* to root@'%'identified by 'root';
UPDATE user SET Password = password ('root') WHERE User = 'root' ; 
flush privileges;
quit"

