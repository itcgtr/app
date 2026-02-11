```sh
# update and upgrade packages
apt update && apt upgrade -y


# install docker
apt install docker.io -y


# configure docker to start on boot
systemctl daemon-reload
systemctl enable docker
systemctl start docker

# pull mongo image
docker pull minio/minio:latest


# list docker images
docker images






# run minio container for developer use
CONTAINER_NAME=gtr_minio_stage
USERNAME="admin"
PASSWORD="adminadmin"
docker run -d \
    --restart unless-stopped \
    -p 9900:9000 \
    -p 9901:9901 \
    --name $CONTAINER_NAME \
    -v /mnt/storage/gtr_minio_stage:/data \
    -e "MINIO_ROOT_USER=$USERNAME" \
    -e "MINIO_ROOT_PASSWORD=$PASSWORD" \
    minio/minio server /data --console-address ":9901"



# list running containers
docker ps -a

# [OPTIONAL] delete container (if needed)
CONTAINER=gtr_minio_stage
docker stop $CONTAINER
docker rm -f $CONTAINER



```
