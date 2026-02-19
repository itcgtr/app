import os
import sys

sys.path.append(os.getcwd())

import dotenv

dotenv.load_dotenv()


# ?General configuration for the application
TITLE = os.getenv("TITLE", "GTR Application Stage") if os.path.isfile("/.dockerenv") else "GTR Application Private"


# ?Database configuration for the application
MONGO_HOST = os.getenv("MONGO_HOST", "mongo_stage") if os.path.isfile("/.dockerenv") else "gtr-server"
MONGO_PORT = 27017
MONGO_USERNAME = os.getenv("MONGO_INITDB_ROOT_USERNAME", "admin")
MONGO_PASSWORD = os.getenv("MONGO_INITDB_ROOT_PASSWORD", "adminadmin")
MONGO_DATABASE = "database"
MONGO_URL = f"mongodb://{MONGO_USERNAME}:{MONGO_PASSWORD}@{MONGO_HOST}:{MONGO_PORT}"
# DATABASE_CONTAINER_NAME = "mongodb_stage"

# ?MinIO configuration for the application
MINIO_HOST = os.getenv("MINIO_HOST", "minio_stage") if os.path.isfile("/.dockerenv") else "gtr-server"
MINIO_PORT = 9000
MINIO_CONSOLE_PORT = 9001
MINIO_USERNAME = os.getenv("MINIO_ROOT_USER", "admin")
MINIO_PASSWORD = os.getenv("MINIO_ROOT_PASSWORD", "adminadmin")
BUCKET_PUBLIC = "public"
MINIO_URL = f"{MINIO_HOST}:{MINIO_PORT}"


# ?Telegram Bot configuration
BOT_TOKEN = os.getenv("BOT_TOKEN", "8209910932:AAEYZtLY8sk_X8kfILfyfGeT_Lyaz5Z9hM4")
TELEGRAM_API_URL = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"


# ?Secret key for security purposes
SECRET_KEY = "gtr_secret_key"


MAX_IMAGE_UPLOAD_SIZE = 10 * 1024 * 1024  # 10 MB
