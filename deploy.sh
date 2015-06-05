#!/bin/sh
#Deploys a CentOS Server ready for django production use
#yum install git -y

#get the scripts from git
#git clone https://github.com/kayibal/deployCentOS.git

### run script from here on server

cd deployCentOs
chmod -R +x *.sh

#utilities and bash aliases and variables
cd utilities
./install.sh
cd ..

#install python 2.7, apache, mod_wsgi
python/install.sh

#install maria db
cd MariaDB
./install.sh
cd ..

#TODO configure ssh

#appname
$appname = 'busao'
$git_folder = 'busding'
$git_url = 'https://kayibal@github.com/rgherdt/busding.git'

#setup django deployement for given appname
#first setup virtualenv and requirements
mkdir /django
cd /django
git clone $git_url
cd $git_folder
mkvirtualenv $appname
pip install -r requirements.txt

#now configure apache and mod_wsgi
