import os
import sys

sys.path.append(os.getcwd())

from server.utilities.Debug import Debug


from minio import Minio

from server.Environment import *


class Storage(Minio):
    def __init__(self):
        super().__init__(
            endpoint=MINIO_URL,
            access_key=MINIO_ROOT_USER,
            secret_key=MINIO_ROOT_PASSWORD,
            secure=False,
        )

    def object_exists(self, bucket_name: str, object_name: str) -> bool:
        try:
            self.stat_object(bucket_name, object_name)
            return True
        except Exception:
            return False
