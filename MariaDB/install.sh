#!/bin/sh
cp MariaDB.repo /etc/yum.repos.d/MariaDB.repo
yum install MariaDB-server MariaDB-client -y
yum install MariaDB-devel.x86_64 -y
service mysql start
chkconfig mysql on
mysql_secure_installation
service mysql restart
mysql -u root -p <<< "CREATE DATABASE IF NOT EXISTS $DB_NAME; CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PW'; GRANT ALL PRIVILEGES ON $DB_NAME . * TO '$DB_USER'@'localhost'; FLUSH PRIVILEGES;"
#mysql -u root -p
