import os
import sys

sys.path.append(os.getcwd())


TITLE = "Development Environment Configuration"


#
APP_PORT = 80
APP_IMAGE_NAME = "app_stage"
APP_CONTAINER_NAME = "app_stage"


# ?Environment configuration for the application
SERVER_HOST = "127.0.0.1"
SERVER_PORT = 8000
SERVER_IMAGE_NAME = "server_stage"
SERVER_CONTAINER_NAME = "server_stage"

# ?Database configuration for the application
DATABASE_HOST = "127.0.0.1"
DATABASE_PORT = 27017
DATABASE_NAME = "database"
DATABASE_USERNAME = "admin"
DATABASE_PASSWORD = "adminadmin"
DATABASE_NAME = "database"
DATABASE_URL = f"mongodb://{DATABASE_USERNAME}:{DATABASE_PASSWORD}@{DATABASE_HOST}:{DATABASE_PORT}"
DATABASE_CONTAINER_NAME = "mongodb_stage"

# ?MinIO configuration for the application
MINIO_HOST = "127.0.0.1"
MINIO_PORT = 9000
MINIO_CONSOLE_PORT = 9001
MINIO_USERNAME = "admin"
MINIO_PASSWORD = "adminadmin"
BUCKET_PUBLIC = "public"
MINIO_URL = f"{MINIO_HOST}:{MINIO_PORT}"
MINIO_CONTAINER_NAME = "minio_stage"
MINIO_VOLUME = "/mnt/storage/minio_stage"


# ?Telegram Bot configuration
BOT_TOKEN = "8209910932:AAEYZtLY8sk_X8kfILfyfGeT_Lyaz5Z9hM4"
TELEGRAM_API_URL = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
TELEGRAM_IMAGE_NAME = "telegram_stage"
TELEGRAM_CONTAINER_NAME = "telegram_stage"


# ?Secret key for security purposes
SECRET_KEY = "dev_secret_key"


MAX_IMAGE_UPLOAD_SIZE = 10 * 1024 * 1024  # 5 MB
