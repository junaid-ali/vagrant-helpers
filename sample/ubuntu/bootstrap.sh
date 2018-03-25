#!/bin/sh
     
echo "#------------------------------------------------------------------------------#
#                            OFFICIAL UBUNTU REPOS                             #
#------------------------------------------------------------------------------#


###### Ubuntu Main Repos
deb http://pk.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse 
deb-src http://pk.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse 

###### Ubuntu Update Repos
deb http://pk.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse 
deb http://pk.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse 
deb http://pk.archive.ubuntu.com/ubuntu/ trusty-proposed main restricted universe multiverse 
deb http://pk.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse 
deb-src http://pk.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse 
deb-src http://pk.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse 
deb-src http://pk.archive.ubuntu.com/ubuntu/ trusty-proposed main restricted universe multiverse 
deb-src http://pk.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse" | sudo tee /etc/apt/sources.list

GW=$(/sbin/ip route | awk '/default/ { print $3 }') ;
sudo route del default gw $GW ;
sudo route add default gw 172.31.81.1 ;
sudo sed -i '/netmask/ a\ \ \ \ \ \ gateway 172.19.0.6' /etc/network/interfaces ;
sudo sed -i -- 's/#deb-src/deb-src/g' /etc/apt/sources.list ;
sudo sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list ;
IP=$(ip addr | awk '/inet/ && /eth0/{sub(/\/.*$/,"",$2); print $2}') ;
sudo sed -i -- 's/ eth0 inet dhcp/ eth0 inet static/g' /etc/network/interfaces ;
sudo sed -i "/iface eth0 inet static/ a\ \ \ \ \ \ address $IP" /etc/network/interfaces ;
#sudo service apt-daily stop ;
#sudo service apt-daily.timer stop;
sudo apt-get update ;
sudo apt-get install software-properties-common python-software-properties vim -y ;
