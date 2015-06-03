#!/bin/sh
cp MariaDB.repo /etc/yum.repos.d/MariaDB.repo
yum install MariaDB-server MariaDB-client -y
yum install MariaDB-devel.x86_64 -y
service mysql start
chkconfig mysql on
mysql_secure_installation
service mysql restart
mysql -u root -p
