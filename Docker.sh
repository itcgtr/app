# docker build -t gtr_telegram_pro:latest .
docker build -t gtr_telegram_pro:latest -f Dockerfile .


CONTAINER_NAME="gtr_telegram_pro"
docker run -d \
    --restart unless-stopped \
    --name $CONTAINER_NAME \
    -e EXAMPLE="example" \
    gtr_telegram_pro:latest





