#!/bin/sh
set -e
source ./config.sh

printf '\n\n----------- Configuration --------------\n\n'
echo 'User: '$DJANGO_USER
echo 'App Name: '$APPNAME
echo 'Git Folder: '$GIT_FOLDER
echo 'Git Clone Url: '$GIT_URL
echo 'Base Directory: '$BASE_URL
echo 'Python Version: '$PYTHON_VERSION
echo 'DB Name: '$DB_NAME
echo 'DB_User: '$DB_USER
echo 'DB_Pass: '$DB_PW
printf "\n\n\n\n"
#Deploys a CentOS Server ready for django production use
#yum install git -y

#get the scripts from git
#git clone https://github.com/kayibal/deployCentOS.git

### run script from here on server

base=$(pwd)
#install python 2.7, apache, mod_wsgi
#source ./python/install.sh
cd $base

#utilities and bash aliases and variables
cd utilities
source ./install.sh
cd ..

#install maria db
cd MariaDB
source ./install.sh
cd ..

printf "\n\n--------DATABASE READY----------\n\n"

echo ""

printf "\n\n--------CREATING USER FOR DJANGO HOSTING--------\n\n"
#setup django deployement for given APPNAME
adduser $DJANGO_USER
passwd $DJANGO_USER
echo "$DJANGO_USER ALL=(ALL:ALL) ALL" >> /etc/sudoers

#TODO configure ssh
mkdir -p /home/$DJANGO_USER/.ssh
chmod 700 /home/$DJANGO_USER/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChAITG6v/lL5Q0FJcN9Jn/6+2q9LC1d5eevoe4BNX8mImlQHUtn+ytuqgRDyjuwSp/rwAoFlnGTjCrsHm3DjgZdkjsxZBtCh+ulDwcaTupgEX+ItMvyUjPU8auxVxXiV3CNr1Oz/UEVwJt6zL5CxsWQf0D44wuPksLuJDZltavweGff4lJTQBKWJooq7yTvYIYUvIdkqNllG4IElFKqVzdzdYdIIWYO+jll0C8vUgf2hE6GAsUrTiX0Hv0JSADU5cKrAk13yg7+7V3VKI5OsUSdwfA9xHGUEi2hpjy0wzy2fOjdfHNxfFERumsyffUvR9dPYryCglc9Tyz3n/oDYqr Alan@Alans-MacBook-Pro.local" > /home/$DJANGO_USER/.ssh/authorized_keys
chmod 600 /home/$DJANGO_USER/.ssh/authorized_keys
chmod 755 /home/$DJANGO_USER

#now configure apache and mod_wsgi
touch /etc/httpd/conf.d/django.conf

echo "Alias /static $BASE_URL/$GIT_FOLDER/static" 	>> /etc/httpd/conf.d/django.conf
echo "<Directory $BASE_URL/$GIT_FOLDER/static>" 	>> /etc/httpd/conf.d/django.conf
echo "	Require all granted"						>> /etc/httpd/conf.d/django.conf
echo "</Directory>"									>> /etc/httpd/conf.d/django.conf

echo "<Directory $BASE_URL/$GIT_FOLDER/$APPNAME/$APPNAME>"	>>/etc/httpd/conf.d/django.conf
echo "    <Files wsgi.py>"									>>/etc/httpd/conf.d/django.conf
echo "        Require all granted"							>>/etc/httpd/conf.d/django.conf
echo "    </Files>"											>>/etc/httpd/conf.d/django.conf
echo "</Directory>"											>>/etc/httpd/conf.d/django.conf

echo "WSGIDaemonProcess $APPNAME python-path=$BASE_URL/$GIT_FOLDER/$APPNAME:/usr/local/share/.virtualenvs/$APPNAME/lib/python$PYTHON_VERSION/site-packages"	>> /etc/httpd/conf.d/django.conf
echo "WSGIProcessGroup $APPNAME"																													>> /etc/httpd/conf.d/django.conf
echo "WSGIScriptAlias / $BASE_URL/$GIT_FOLDER/$APPNAME/wsgi.py"																			>> /etc/httpd/conf.d/django.conf

ip=$(curl -s ifconfig.me)
echo "ServerName "$ip >> /etc/httpd/conf/httpd.conf
service httpd restart

printf "\n\n---------Almost done! checking out source code from git-------------\n\n"

#setup virtualenv and requirements
mkdir -p $BASE_URL
cd $BASE_URL
git clone $GIT_URL $GIT_FOLDER
cd $GIT_FOLDER
mkvirtualenv -r requirements.txt $APPNAME || true
echo $APPNAME > .venv

usermod -a -G $DJANGO_USER apache
chmod 710 $BASE_URL/$GIT_FOLDER
chown -R $DJANGO_USER:$DJANGO_USER $BASE_URL
#clean up
rm -r -f ~/deployCentOS

#prepare for db sync and static file collect
echo "DONE"
vim -c /DATABASES $APPNAME/settings.py
#./manage.py makemigrations
#./manage.py migrate
#./manage.py collectstatic

