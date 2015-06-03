#!/bin/sh

yum install git -y
python/install.sh
cd MariaDB
./install.sh

#utilities and bash aliases and variables
cd utilities
./install.sh