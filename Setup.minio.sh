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




# run mongo container
CONTAINER_NAME=minio_pro
USERNAME="admin"
PASSWORD="itcgtr2026"
docker run -d \
  --restart unless-stopped \
  -p 9000:9000 \
  -p 9001:9001 \
  --name $CONTAINER_NAME \
  -v /mnt/storage/minio_product:/data \
  -e "MINIO_ROOT_USER=$USERNAME" \
  -e "MINIO_ROOT_PASSWORD=$PASSWORD" \
  minio/minio server /data --console-address ":9001"


# run minio container for developer use
CONTAINER_NAME=minio_dev
USERNAME="admin"
PASSWORD="adminadmin"
docker run -d \
    --restart unless-stopped \
    -p 9900:9000 \
    -p 9901:9901 \
    --name $CONTAINER_NAME \
    -v /mnt/storage/minio_dev:/data \
    -e "MINIO_ROOT_USER=$USERNAME" \
    -e "MINIO_ROOT_PASSWORD=$PASSWORD" \
    minio/minio server /data --console-address ":9901" 



# list running containers
docker ps -a

# [OPTIONAL] delete container (if needed)
CONTAINER=minio_dev
docker stop $CONTAINER
docker rm -f $CONTAINER