import os
import sys

sys.path.append(os.getcwd())

from Environment import *


os.system("docker pull mongo:latest")

script = rf"""
docker run -d \
    --restart unless-stopped \
    --name {DATABASE_CONTAINER_NAME} \
    -p {DATABASE_PORT}:27017 \
    -e MONGO_INITDB_ROOT_USERNAME="{DATABASE_USERNAME}" \
    -e MONGO_INITDB_ROOT_PASSWORD="{DATABASE_PASSWORD}" \
    mongo:latest
"""


if os.name == "nt":  # Windows
    # remove lines starting with '#'
    script = "\n".join(line for line in script.splitlines() if not line.strip().startswith("#"))

    # remove line continuations and extra spaces, flatten to single line
    script = script.replace("\\\n", " ")
    script = " ".join(script.split())


print(script)
os.system(script)

# run
# python server/services/mongodb/Setup.py
