



# create a volume for mongo data
docker volume create volume_mongo_stage

# list volumes
docker volume ls

# remove unused volumes
docker volume prune -f



# backup volume data
docker run --rm -v mongo_stage:/data -v C:/backup/:/backup ubuntu tar cvf /backup/mongo_stage_backup.tar /data


####################################


docker pull mongo:latest

# C:\Users\muysengly\Documents\minio_data

# create docker container minio
docker run -d `
    --restart unless-stopped `
    --name mongo_stage `
    -p 27017:27017 `
    -v volume_mongo_stage:/data `
    -e MONGO_INITDB_ROOT_USERNAME="admin" `
    -e MONGO_INITDB_ROOT_PASSWORD="adminadmin" `
    mongo:latest

# save container as image
# CONTAINER_NAME=mongo_stage
docker commit mongo_stage mongo_stage:latest

# save image as file
# CONTAINER_NAME=mongo_stage
docker save -o mongo_stage.tar mongo_stage:latest



# list running containers
docker ps -a

# delete container
# CONTAINER_NAME=mongo_stage
docker stop mongo_stage
docker rm -f mongo_stage


# load saved image file
# CONTAINER_NAME=mongo_stage
docker load -i mongo_stage.tar

# run container from image
# CONTAINER_NAME=mongo_stage
# docker run -it --name mongo_stage mongo_stage:latest bash
docker run -d `
    --restart unless-stopped `
    --name mongo_stage `
    -p 27017:27017 `
    -v volume_mongo_stage:/data `
    mongo_stage:latest