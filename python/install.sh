# wget -O install_python.sh https://gist.github.com/raw/777001/install_python.sh
# chmod +x install_python.sh
# ./install_python.sh

#!/bin/sh

echo "******************************************"
echo "Configure Centos box with a recent version"
echo "of Python. "
echo " - jgumbley 12/jan/11"
echo "******************************************"

echo " - Get source for Python"
cd /usr/local/src
wget http://www.python.org/ftp/python/2.7.1/Python-2.7.1.tgz
tar xvfz Python-2.7.1.tgz

echo " - Install compilers"
yum -y install gcc gdbm-devel readline-devel ncurses-devel zlib-devel bzip2-develsqlite-devel db4-devel openssl-devel tk-devel bluez-libs-devel make

echo " - Compile Python source"
cd Python-2.7.1
./configure --prefix=/opt/python2.7.1 --with-threads --enable-shared
make
make install

echo " - Add shared libraries in"
touch /etc/ld.so.conf.d/opt-python2.7.1.conf
echo "/opt/python2.7.1/lib/" >> /etc/ld.so.conf.d/opt-python2.7.1.conf
ldconfig

echo " - Create SymLink to updated version"
ln -sf /opt/python2.7.1/bin/python /usr/bin/python2.7

echo " - Install SetupTools."
cd /usr/local/src
wget http://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg
sh setuptools-0.6c11-py2.7.egg --prefix=/opt/python2.7.1

echo " - Install pip."
/opt/python2.7.1/bin/easy_install pip
ln -sf /opt/python2.7.1/bin/pip /usr/bin/pip

echo " - Install virtualenv."
pip install virtualenv
ln -sf /opt/python2.7.1/bin/virtualenv /usr/bin/virtualenv

echo " - Pipe alias into .zshrc "
echo "alias python=/opt/python2.7.1/bin/python" >> ~/.zshrc
source ~/.zshrc

# wget -O install_python.sh https://gist.github.com/raw/777001/install_python.sh
# chmod +x install_python.sh
# ./install_python.sh

#!/bin/sh

echo "******************************************"
echo "Configure Centos box with apache and "
echo "mod_wsgi for running flask apps "
echo " - jgumbley 15/jan/11"
echo "******************************************"

echo " # install required apache pre-reqs "
yum -y install httpd httpd-devel

echo " # download mod_wsgi source "
cd /usr/local/src/
wget http://modwsgi.googlecode.com/files/mod_wsgi-3.3.tar.gz
tar xvfz mod_wsgi-3.3.tar.gz

echo " # compile mod_wsgi source "
cd mod_wsgi-3.3
./configure --with-python=/opt/python2.7.1/bin/python
make
make install

echo " # pipe module into httpd config"
echo "LoadModule wsgi_module /usr/lib64/httpd/modules/mod_wsgi.so" >> /etc/httpd/conf/httpd.conf
service httpd restart

#symlinking python library for gcc
ln -s /opt/python2.7.1/lib/python2.7/config/libpython2.7.a /usr/local/lib

#installing virtualenvwrapper
pip install virtualenvwrapper
