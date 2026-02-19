import platform
from rich import print

from server.Environment import *


def debug(string: str):
    if platform.node() != "gtr-server":  # not production
        print(string)
