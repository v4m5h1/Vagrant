#!/bin/bash

## Provisioning necessary softwares on the Virtual Machine

# Installing JDK
echo "Installing JDK"
apt-get update
apt-get install -y openjdk-8-jdk
java -version

# Installing Jenkins
echo "Installing Jenkins"
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
echo 'deb https://pkg.jenkins.io/debian-stable binary/' >> /etc/apt/sources.list
apt-get update
apt-get install -y jenkins
# If you need to run jenkins on different port other than 8080, use the below command
# sudo sed 's/HTTP_PORT=8080/HTTP_PORT=9999/g' /etc/default/jenkins
# service jenkins restart

# Installing Ansible
echo "Installing Ansible"
apt-get update
apt-get install software-properties-common
apt-add-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible
ansible --version

# Installing Docker
echo "Installing Docker"
apt-get install -y docker.io
systemctl start docker
usermod -aG docker ${USER}
docker --version

# optional tools for learning 
apt-get install -y -q ipvsadm tree net-tools openssh-server vim
