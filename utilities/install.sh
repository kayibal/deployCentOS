#!/bin/sh

echo "alias phome=$BASE_URL/$GIT_FOLDER" >> custom.sh
#Virtualenv configuration
mkdir -p /usr/local/share/.virtualenvs
chmod -R 755 /usr/local/share/.virtualenvs
cp autoVenv.sh /usr/local/share/autoVenv.sh
cp custom.sh /usr/local/share/custom.sh
chmod 755 /usr/local/share/custom.sh
chmod 755 /usr/local/share/autoVenv.sh
echo 'source /usr/local/share/custom.sh' >> /etc/bashrc


#activate all changes
source /usr/local/share/custom.sh

#User tools
yum install mlocate -y
yum install vim -y