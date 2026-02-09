docker build -t gtr_telegram_product:latest -f server/services/telegram_bot/product/Dockerfile .


CONTAINER_NAME="gtr_telegram_product"
docker run -d \
    --restart unless-stopped \
    --name $CONTAINER_NAME \
    -e EXAMPLE="example" \
    gtr_telegram_product:latest
