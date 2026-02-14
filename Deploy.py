import os
import sys

sys.path.append(os.getcwd())

from Environment import *


os.system(rf"""docker build -t {APP_IMAGE_NAME}:latest -f Dockerfile .""")

os.system(rf"""docker stop {APP_CONTAINER_NAME}""")
os.system(rf"""docker rm -f {APP_CONTAINER_NAME}""")

os.system(rf"""docker run -d --restart unless-stopped --name {APP_CONTAINER_NAME} -p {SERVER_PORT}:80 {APP_IMAGE_NAME}:latest""")

# run
# python server/services/telegram_bot/Deploy.py
