Creates Wiki in Docker containers:
 - Mediawiki
 - DataBase (MariaDB)
 - Parsoid & RESTBase


# PREPARATIONS
export http_proxy='http://192.168.50.77:8080' && export https_proxy='http://192.168.50.77:8080'
sudo apt update && sudo apt upgrade -y
sudo apt-get remove docker docker-engine docker.io
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common vim git -y
sudo apt-get install python-pip python-dev build-essential -y


# INSTALL DOCKER
https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce -y
sudo systemctl status docker
sudo docker run hello-world


# DOCKER WITHOUT SUDO
sudo usermod -aG docker ${USER}
logout
docker ps


# INSTALL DOCKER-COMPOSE
https://docs.docker.com/compose/install/
sudo -E pip install -U pip
sudo -E pip install -U docker-compose
docker-compose --version


# PREPARATIONS BEFORE DEPLOY
git clone https://github.com/AlexanderKoryagin/mediawiki-containers.git
cd mediawiki-containers
source .env
sudo mkdir -p ${MEDIAWIKI_LOCAL_PWD}
sudo chmod 777 ${MEDIAWIKI_LOCAL_PWD}
...edit files...
docker-compose up
OR
docker-compose up -d  # for Detached mode

------------------
# DELETE ALL
docker-compose down --rmi all
source .env
sudo rm -rf ${MEDIAWIKI_LOCAL_PWD:-default}/*
