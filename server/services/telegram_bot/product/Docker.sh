docker build \
    -t gtr_telegram_product:latest \
    -f server/services/telegram_bot/product/Dockerfile .


# list running containers
# docker ps -a


CONTAINER_NAME="gtr_telegram_product"
docker stop $CONTAINER_NAME
docker rm -f $CONTAINER_NAME
docker run -d \
    --restart unless-stopped \
    --name $CONTAINER_NAME \
    gtr_telegram_product:latest
