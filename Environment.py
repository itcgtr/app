import os
import sys

sys.path.append(os.getcwd())

import dotenv

dotenv.load_dotenv()


# ?General configuration for the application
TITLE = os.getenv("TITLE", "GTR Application Stage")


# ?Environment configuration for the application
SERVER_HOST = os.getenv("SERVER_HOST", "127.0.0.1")
SERVER_PORT = os.getenv("SERVER_PORT", 8000)

# ?Database configuration for the application
DATABASE_HOST = os.getenv("DATABASE_HOST", "mongo_stage")  # for docker compose
DATABASE_PORT = os.getenv("DATABASE_PORT", 27017)
DATABASE_USERNAME = os.getenv("DATABASE_USERNAME", "admin")
DATABASE_PASSWORD = os.getenv("DATABASE_PASSWORD", "adminadmin")
DATABASE_NAME = os.getenv("DATABASE_NAME", "database")
DATABASE_URL = f"mongodb://{DATABASE_USERNAME}:{DATABASE_PASSWORD}@{DATABASE_HOST}:{DATABASE_PORT}"
# DATABASE_CONTAINER_NAME = "mongodb_stage"

# ?MinIO configuration for the application
# MINIO_HOST = "127.0.0.1"
MINIO_HOST = os.getenv("MINIO_HOST", "minio_stage")  # for docker compose
MINIO_PORT = os.getenv("MINIO_PORT", 9000)
MINIO_CONSOLE_PORT = os.getenv("MINIO_CONSOLE_PORT", 9001)
MINIO_USERNAME = os.getenv("MINIO_USERNAME", "admin")
MINIO_PASSWORD = os.getenv("MINIO_PASSWORD", "adminadmin")
BUCKET_PUBLIC = os.getenv("BUCKET_PUBLIC", "public")
MINIO_URL = f"{MINIO_HOST}:{MINIO_PORT}"


# ?Telegram Bot configuration
BOT_TOKEN = os.getenv("BOT_TOKEN", "8209910932:AAEYZtLY8sk_X8kfILfyfGeT_Lyaz5Z9hM4")
TELEGRAM_API_URL = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"


# ?Secret key for security purposes
SECRET_KEY = os.getenv("SECRET_KEY", "gtr_secret_key")


MAX_IMAGE_UPLOAD_SIZE = 10 * 1024 * 1024  # 10 MB
