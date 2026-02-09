# update and upgrade packages
apt update && apt upgrade -y


# install docker
apt install docker.io -y


# configure docker to start on boot
systemctl daemon-reload
systemctl enable docker
systemctl start docker

# pull mongo image
docker pull mongo:latest

# list docker images
docker images



# list volume
docker volume ls

# delete all unused volumes
docker volume prune -f 





# run mongo container
CONTAINER_NAME=gtr_mongodb_stage
USERNAME="admin"
PASSWORD="adminadmin"
docker run -d \
    --restart unless-stopped \
    --name $CONTAINER_NAME \
    -p 27027:27017 \
    -e MONGO_INITDB_ROOT_USERNAME="$USERNAME" \
    -e MONGO_INITDB_ROOT_PASSWORD="$PASSWORD" \
    mongo:latest


# list running containers
docker ps -a

# [OPTIONAL] delete container (if needed)
CONTAINER=gtr_mongodb_stage
docker stop $CONTAINER
docker rm -f $CONTAINER