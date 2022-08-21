#! /bin/bash

set -e

if [[ $(amazon-linux-extras list | grep nginx | awk '{ print $3 }') != 'enabled' ]] 
then
    echo "Enabling Nginx package"
    amazon-linux-extras enable nginx1
    yum clean metadata
fi

echo  "Updating packages"
yum update -y
echo "Installing Nginx"
yum -y install nginx

if [[ $(systemctl is-active nginx) != "active" ]]
then
    echo "Starting service nginx"
    systemctl start nginx
else
    echo "Nginx service is running"
fi

if [[ $(systemctl is-enabled nginx) != "enabled" ]]
then
    echo "Enabling service nginx"
    systemctl enable nginx
fi