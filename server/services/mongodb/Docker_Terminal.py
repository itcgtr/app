import os
import sys

sys.path.append(os.getcwd())

from Environment import *

script = rf"""
docker logs --follow {DATABASE_CONTAINER_NAME}
"""

print(script)
os.system(script)


# run
# python server/services/mongodb/Terminal.py
