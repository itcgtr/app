import os
import sys

sys.path.append(os.getcwd())

from Environment import *


os.system(rf"""docker build -t {TELEGRAM_IMAGE_NAME}:latest -f server/services/telegram_bot/Dockerfile .""")

os.system(rf"""docker stop {TELEGRAM_CONTAINER_NAME}""")
os.system(rf"""docker rm -f {TELEGRAM_CONTAINER_NAME}""")

os.system(rf"""docker run -d --restart unless-stopped --name {TELEGRAM_CONTAINER_NAME} {TELEGRAM_IMAGE_NAME}:latest""")

# run
# python server/services/telegram_bot/Deploy.py
