import os
import sys

sys.path.append(os.getcwd())

from pymongo import AsyncMongoClient
from typing import *

from Environment import *


class MongoDB:

    _client = AsyncMongoClient(
        DATABASE_URL,
        connectTimeoutMS=5000,  # 5 second
        serverSelectionTimeoutMS=5000,  # 5 second
    )
    _db = _client["database"]

    async def list_collection_names(self):
        return await self._db.list_collection_names()

    c_credential = _db["c_credential"]
    c_credential_reset_otp = _db["c_credential_reset_otp"]
    c_credential_signup_otp = _db["c_credential_signup_otp"]

    c_attendance = _db["c_attendance"]
    c_attendance_code = _db["c_attendance_code"]

    c_class_name = _db["c_class_name"]

    c_class_type = _db["c_class_type"]

    c_contributor = _db["c_contributor"]

    c_counter = _db["c_counter"]

    c_template = _db["c_template"]

    v_attendance = _db["v_attendance"]


if __name__ == "__main__":
    import asyncio

    async def main():
        db = MongoDB()
        data = await db.c_credential.find_one({"username": "muysengly"})
        print(data)

    asyncio.run(main())
