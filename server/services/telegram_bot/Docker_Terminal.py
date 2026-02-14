import os
import sys

sys.path.append(os.getcwd())

from Environment import *

script = rf"""
docker logs --follow {TELEGRAM_CONTAINER_NAME}
"""

print(script)
os.system(script)


# run
# python server/services/telegram_bot/Terminal.py
