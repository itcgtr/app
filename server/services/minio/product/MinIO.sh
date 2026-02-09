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
CONTAINER_NAME=gtr_minio_product
USERNAME="admin"
PASSWORD="itcgtr2026"
docker run -d \
  --restart unless-stopped \
  -p 9000:9000 \
  -p 9001:9001 \
  --name $CONTAINER_NAME \
  -v /mnt/storage/gtr_minio_product:/data \
  -e "MINIO_ROOT_USER=$USERNAME" \
  -e "MINIO_ROOT_PASSWORD=$PASSWORD" \
  minio/minio server /data --console-address ":9001"






# list running containers
docker ps -a

# [OPTIONAL] delete container (if needed)
CONTAINER=gtr_minio_product
docker stop $CONTAINER
docker rm -f $CONTAINER