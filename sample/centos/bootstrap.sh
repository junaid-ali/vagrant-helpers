#!/bin/sh

GW_PUBLIC=172.31.81.1 ;

sudo yum -y install epel-release ;
sudo yum-config-manager --enable epel ;
sudo yum update ;
sudo yum -y install net-tools vim ;

sudo systemctl restart network.service ;

GW_VAGRANT=$(/sbin/ip route | awk '/default/ { print $3 }') ;
INTERFACE_VAGRANT=$(/sbin/ip route | awk '/default/ { print $5 }')
IP_VAGRANT=$(/sbin/ip addr show $INTERFACE_VAGRANT | grep 'inet ' | cut -f2 | awk '{ print $2}' | cut -d/ -f1)
sudo route del default gw $GW_VAGRANT ;
sudo route add default gw $GW_PUBLIC ;

INTERFACE_PUBLIC=$(/sbin/ip route | awk '/default/ { print $5 }')

echo "NM_CONTROLLED=no
BOOTPROTO=none
ONBOOT=yes
IPADDR=${IP_VAGRANT}
NETMASK=255.255.255.0
DEVICE=${INTERFACE_VAGRANT}
PEERDNS=no" | sudo tee /etc/sysconfig/network-scripts/ifcfg-${INTERFACE_VAGRANT} > /dev/null

echo "GATEWAY=${GW_PUBLIC}" | sudo tee -a /etc/sysconfig/network-scripts/ifcfg-${INTERFACE_PUBLIC} > /dev/null
echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf > /dev/null
