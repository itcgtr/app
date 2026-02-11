docker build \
    -t gtr_telegram_stage:latest \
    -f server/services/telegram_bot/stage/Dockerfile .


# list running containers
# docker ps -a


CONTAINER_NAME="gtr_telegram_stage"
docker stop $CONTAINER_NAME
docker rm -f $CONTAINER_NAME
docker run -d \
    --restart unless-stopped \
    --name $CONTAINER_NAME \
    gtr_telegram_stage:latest