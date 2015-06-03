#!/bin/sh

#set python version
echo 'alias python=python2.7' >> /etc/bash.bashrc
cp autoVenv.sh usr/local/share/autoVenv.sh
#Virtualenv configuration
mkdir usr/local/share/.virtualenvs
chmod -R 755 usr/local/share/.virtualenvs
echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7' >> /etc/bash.bashrc
echo 'export WORKON_HOME=usr/local/share/.virtualenvs' >> /etc/bash.bashrc
echo 'export PROJECT_HOME=$HOME/projects' >> ~/etc/bash.bashrc
echo 'source /opt/python2.7.1/bin/virtualenvwrapper.sh' >> /etc/bash.bashrc
echo 'source usr/local/share/autoVenv.sh' >> /etc/bash.bashrc

#User tools
sudo yum install mlocate
