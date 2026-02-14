import os
import sys

sys.path.append(os.getcwd())

from Environment import *


os.system(rf"""docker build -t {SERVER_IMAGE_NAME}:latest -f server/Dockerfile .""")

os.system(rf"""docker stop {SERVER_CONTAINER_NAME}""")
os.system(rf"""docker rm -f {SERVER_CONTAINER_NAME}""")

os.system(rf"""docker run -d --restart unless-stopped --name {SERVER_CONTAINER_NAME} -p {SERVER_PORT}:8000 {SERVER_IMAGE_NAME}:latest""")

# run
# python server/Deploy.py
