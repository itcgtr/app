





flutter create . --platforms=web




# enter root user
sudo su

# update and upgrade packages
apt update && apt upgrade -y

# install docker
apt install docker.io -y
# snap install docker


# configure docker to start on boot
systemctl daemon-reload
systemctl enable docker
systemctl start docker


# pull mongo image
docker pull minio/minio:latest
docker pull mongo:latest
docker pull ubuntu:latest

# list docker images
docker images

# list volume
docker volume ls

# delete all unused volumes
docker volume prune -f






#


sudo apt install python3-venv -y

python -m venv .venv
source .venv/bin/activate

python -m pip install --upgrade pip

# dependencies
pip install fastapi[all]
pip install uvicorn
pip install pillow
pip install pymongo
pip install minio
pip install requests
pip install python-telegram-bot

# development dependencies
pip install jupyter

# end




###########################################


# run mongo container
CONTAINER_NAME=minio_product
USERNAME="admin"
PASSWORD="itcgtr2026"
docker run -d \
  --name $CONTAINER_NAME \
  --restart unless-stopped \
  -p 9000:9000 \
  -p 9001:9001 \
  -e "MINIO_ROOT_USER=$USERNAME" \
  -e "MINIO_ROOT_PASSWORD=$PASSWORD" \
  minio/minio server /data --console-address ":9001"






# list running containers
docker ps -a

# [OPTIONAL] delete container (if needed)
CONTAINER=minio_product
docker stop $CONTAINER
docker rm -f $CONTAINER



######################################################################

# pull ubuntu latest image
docker pull ubuntu:latest


# run ubuntu container
CONTAINER_NAME=gtr_ubuntu_test
docker run -it \
    --name $CONTAINER_NAME \
    ubuntu:latest bash

apt update && apt upgrade -y

# save container
CONTAINER_NAME=minio_product
docker commit $CONTAINER_NAME $CONTAINER_NAME:latest

# save as image file
CONTAINER_NAME=minio_product
docker save -o $CONTAINER_NAME.tar $CONTAINER_NAME:latest

# load saved image file
CONTAINER_NAME=minio_product
docker load -i $CONTAINER_NAME.tar

# load saved container
CONTAINER_NAME=minio_product
docker run -it --name $CONTAINER_NAME $CONTAINER_NAME:latest bash

######################################################################

