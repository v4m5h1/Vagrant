#!/bin/bash


## Provisioning necessary softwares on the Virtual Machine
echo "Installing JDK"
apt-get update
add-apt-repository -y ppa:openjdk-r/ppa && apt-get update && apt-get install -y openjdk-8-jdk curl unzip
java -version

echo "Installing Jenkins"
wget --no-check-certificate https://pkg.jenkins.io/debian/binary/jenkins_2.89_all.deb
dpkg -i jenkins_2.89_all.deb
# If you need to run jenkins on different port other than 8080, use the below command
# sudo sed 's/HTTP_PORT=8080/HTTP_PORT=9999/g' /etc/default/jenkins
service jenkins restart

echo "Installing Ansible"
apt-get install -y ansible
ansible --version

echo "Setting up Artifactory and SonarQube"
wget --no-check-certificate https://bintray.com/jfrog/artifactory/download_file?file_path=jfrog-artifactory-oss-5.4.3.zip -O jfrog-artifactory-oss-5.4.3.zip
wget --no-check-certificate https://bintray.com/sonarsource/Distribution/download_file?file_path=sonarqube%2Fsonarqube-5.6.6.zip -O sonarqube-5.6.6.zip
wget --no-check-certificate https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.0.3.778-linux.zip -O sonar-scanner-cli-3.0.3.778.zip

unzip jfrog-artifactory-oss-5.4.3.zip
mkdir -p ~/DEVOPS-TOOLS/
cp -R artifactory-oss-5.4.3/ ~/DEVOPS-TOOLS/
echo "Artifactory Control Script is available at ~/DEVOPS-TOOLS/artifactory-oss-5.4.3/bin/artifactory.sh <start | stop>"
unzip sonarqube-5.6.6.zip
cp -R sonarqube-5.6.6/ ~/DEVOPS-TOOLS/
echo "SonarQube Control Script is available at ~/DEVOPS-TOOLS/sonarqube-5.6.6/bin/linux-x86-64/sonar.sh <start | stop>"

## TODO: Install Nagios as well


##### TODO: Work on Docker setup #####

# Approach 1 => New
## Install test version of docker engine, also shell completions
curl -fsSL https://test.docker.com/ | sh

# Add the vagrant user to the docker group
usermod -aG docker vagrant

# Configure the docker engine
# Daemon options: https://docs.docker.com/engine/reference/commandline/dockerd/
# Set both unix socket and tcp to make it easy to connect both locally and remote
# You can add TLS for added security (docker-machine does this automatically)
cat > /etc/docker/daemon.json <<END
{
    "hosts": [ 
        "unix://",
        "tcp://0.0.0.0:2375"
    ],
    "experimental": true,
    "debug": true,
    "metrics-addr": "0.0.0.0:9323" 
}
END

# You can't pass both CLI args and use the daemon.json for parameters, 
# so I'm using the RPM systemd unit file because it doesn't pass any args 
# This version changes the following as of 17.03:
#  - Removes Requires=docker.socket
#  - Removes docker.socket from After
#  - Sets LimitNOFILE=infinity
#  - Removes -H fd:// from ExecStart 
wget -O /lib/systemd/system/docker.service https://raw.githubusercontent.com/docker/docker/v17.03.0-ce/contrib/init/systemd/docker.service.rpm
systemctl daemon-reload
systemctl restart docker

# optional tools for learning 
apt-get install -y -q ipvsadm tree
# lsns is helpful from util-linux, this is installed already

# Approach 2 => Old
: '
echo "Installing Docker"
sudo apt-get install -y apt-transport-https ca-certificates software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
docker --version
sudo chmod 777 /var/run/docker.sock
sudo usermod -aG docker jenkins
sudo usermod -aG docker $USER
echo "################## Docker Install completed #####################\n"
'