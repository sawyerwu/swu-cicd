#!/bin/bash
HOSTNAME=$(cat /etc/hostname)

read -p "Please input your expected hostname: " NEWHOSTNAME
echo $NEWHOSTNAME > /etc/hostname
sed -i "s|$HOSTNAME|$NEWHOSTNAME|g" /etc/hosts

yum update -y
yum install htop -y

systemctl stop firewalld
systemctl disable firewalld

sed -i 's/enforcing/disabled/' /etc/selinux/config
setenforce 0

swapoff -a
sed -i '/swap/d' /etc/fstab

reboot