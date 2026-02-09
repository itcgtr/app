docker build -t gtr_telegram_stage:latest -f server/services/telegram_bot/stage/Dockerfile .


CONTAINER_NAME="gtr_telegram_stage"
docker run -d \
    --restart unless-stopped \
    --name $CONTAINER_NAME \
    gtr_telegram_stage:latest





