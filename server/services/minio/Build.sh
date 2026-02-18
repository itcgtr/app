

# C:\Users\muysengly\Documents\minio_data

# create docker container minio
docker run -d `
    --name minio_stage `
    -p 9000:9000 `
    -p 9001:9001 `
    -v C:/minio/minio_data/:/data `
    -e "MINIO_ROOT_USER=minioadmin" `
    -e "MINIO_ROOT_PASSWORD=minioadmin" `
    minio/minio server /data --console-address ":9001" > /var/log/minio/minio.log 2>&1

    # -v C:/minio/minio_logs/:/var/log/minio `  

# save container as image
# CONTAINER_NAME=minio_stage
docker commit minio_stage minio_stage:latest

# save image as file
# CONTAINER_NAME=minio_stage
docker save -o minio_stage.tar minio_stage:latest

# load saved image file
# CONTAINER_NAME=minio_stage
docker load -i minio_stage.tar

# run container from image
# CONTAINER_NAME=minio_stage
docker run -it --name minio_stage minio_stage:latest bash