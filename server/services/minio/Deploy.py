import os
import sys

sys.path.append(os.getcwd())

from Environment import *


os.system("docker pull minio/minio:latest")

script = rf"""
docker run -d \
  --restart unless-stopped \
  -p {MINIO_PORT}:9000 \
  -p {MINIO_CONSOLE_PORT}:9001 \
  --name {MINIO_CONTAINER_NAME} \
  -v {MINIO_VOLUME}:/data \
  -e "MINIO_ROOT_USER={MINIO_USERNAME}" \
  -e "MINIO_ROOT_PASSWORD={MINIO_PASSWORD}" \
  minio/minio server /data --console-address ":{MINIO_CONSOLE_PORT}"
"""


if os.name == "nt":  # Windows
    # remove lines starting with '#'
    # script = "\n".join(line for line in script.splitlines() if not line.strip().startswith("#"))

    # remove line start with -v
    script = "\n".join(line for line in script.splitlines() if not line.strip().startswith("-v "))

    # remove line continuations and extra spaces, flatten to single line
    script = script.replace("\\\n", " ")
    script = " ".join(script.split())


print(script)
os.system(script)

# run
# python server/services/minio/Setup.py
