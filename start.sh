#!/bin/sh
yum install git -y

#get the scripts from git
git clone https://github.com/kayibal/deployCentOS.git
cd deployCentOS
find ./ -name "*.sh" -exec chmod +x {} \;
cd ..

echo "edit configuration and execute deploy.sh"
#open configuration
vim config.sh