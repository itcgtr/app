import os
import sys


sys.path.append(os.getcwd())

from typing import *
from fastapi import *
from fastapi.security import *
from fastapi.responses import *

import json
import secrets
import requests
from io import BytesIO
from bson import json_util
from datetime import datetime


from server.Environment import *
from server.utilities.Security import HASH
from server.utilities.Database import Mongo_DB
from server.utilities.Storage import Storage
from server.utilities.Token import Token
from server.utilities.Debug import debug


router = APIRouter()

# image_path = "assets/credential"

oa = OAuth2PasswordBearer(tokenUrl="credential/signin")
se = HASH(SECRET_KEY)
db = Mongo_DB()
s3 = Storage()
tk = Token()


@router.post("/signup_otp", deprecated=0)
async def _(
    telegram_id: str = Form(..., json_schema_extra={"example": ""}),
):
    try:

        # validate input data
        if telegram_id is None or telegram_id == "":
            return Response(status_code=status.HTTP_400_BAD_REQUEST)

        # generate otp code
        signup_otp = f"{secrets.randbelow(1000000):06d}"
        print(signup_otp)

        # prepare data
        body = {
            "telegram_id": telegram_id,
            "otp": signup_otp,
            "created_at": datetime.now(),
        }
        print(body)

        # check existing telegram_id in database
        existing = await db.c_credential_signup_otp.find_one({"telegram_id": telegram_id})
        if existing:
            await db.c_credential_signup_otp.update_one(
                {"telegram_id": telegram_id},
                {"$set": {"otp": signup_otp, "requested_at": datetime.now()}},
            )
        else:
            await db.c_credential_signup_otp.insert_one(body)

        print("existing")

        # send otp code via telegram bot
        message = f"Your OTP Code is:"
        requests.get(f"""https://api.telegram.org/bot{BOT_TOKEN}/sendMessage?chat_id={telegram_id}&text={message}""")
        # # debug(responses.text)
        requests.get(f"""https://api.telegram.org/bot{BOT_TOKEN}/sendMessage?chat_id={telegram_id}&text={signup_otp}""")
        # # debug(responses.text)

        # debug("otp sent")

        return 1

    except Exception as e:
        print(e)
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/signup", deprecated=0)
async def _(
    username: str = Form(..., json_schema_extra={"example": ""}),
    password: str = Form(..., json_schema_extra={"example": ""}),
    telegram_id: str = Form(..., json_schema_extra={"example": ""}),
    signup_otp: str = Form(..., json_schema_extra={"example": ""}),
):

    try:

        # validate otp
        telegram_otp = await db.c_credential_signup_otp.find_one({"telegram_id": telegram_id})
        # debug(f"telegram_otp : {telegram_otp}")

        # validate telegram_id
        if not telegram_otp:
            return Response(status_code=status.HTTP_400_BAD_REQUEST)

        # validate otp
        if telegram_otp["otp"] != signup_otp:
            return Response(status_code=status.HTTP_400_BAD_REQUEST)

        # create user
        user = {
            "username": username,
            "password_hash": se.to_hash(password),
            "telegram_id": telegram_id,
            "created_at": datetime.now(),
        }

        # debug(user)

        # insert user into database
        await db.c_credential.insert_one(user)

        # delete otp record after successful registration
        await db.c_credential_signup_otp.delete_one({"telegram_id": telegram_id})

        # debug("registered")

        return "registered"

    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/signin", deprecated=0)
async def _(
    username: str = Form(..., json_schema_extra={"example": ""}),
    password: str = Form(..., json_schema_extra={"example": ""}),
):
    try:

        # debug(f"username : {username}")
        # debug(f"password : {password}")

        # 1. verify username and password
        data = {
            "username": username,
            "password_hash": se.to_hash(password),
        }
        # debug(f"data : {data}")

        user = await db.c_credential.find_one(data)
        # debug(f"user : {user}")

        if not user:
            return Response(status_code=status.HTTP_401_UNAUTHORIZED)

        # debug(f"user token : {user.get('token')}")

        if user.get("token"):
            return {"token_type": "bearer", "access_token": user["token"]}

        # 2. generate token
        token = tk.gen(32)
        # debug(f"token : {token}")

        # 3. store token into database
        await db.c_credential.update_one(
            {"_id": user["_id"]},
            {
                "$set": {
                    "token": token,
                }
            },
        )

        result = {"token_type": "bearer", "access_token": token}

        # debug(f"result : {result}")

        return result

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/reset_otp", deprecated=0)
async def _(
    telegram_id: str = Form(..., json_schema_extra={"example": ""}),
):
    try:
        # validate telegram_id in database
        user = await db.c_credential.find_one({"telegram_id": telegram_id})
        if not user:
            return Response(status_code=status.HTTP_400_BAD_REQUEST)
        # debug(f"user : {user}")

        user_id = user["_id"]

        # generate reset otp code
        reset_otp = f"{secrets.randbelow(1000000):06d}"
        # debug(f"reset_otp : {reset_otp}")

        # prepare data
        body = {
            "user_id": user_id,
            "telegram_id": telegram_id,
            "reset_otp": reset_otp,
            "requested_at": datetime.now(),
        }
        # debug(f"body : {body}")

        # check existing telegram_id in database
        existing = await db.c_credential_reset_otp.find_one({"user_id": user_id})
        # debug(f"existing : {existing}")
        if existing:
            await db.c_credential_reset_otp.update_one(
                {"user_id": user_id},
                {
                    "$set": {
                        "reset_otp": reset_otp,
                        "requested_at": datetime.now(),
                    }
                },
            )
        else:
            await db.c_credential_reset_otp.insert_one(body)

        # send username and reset otp code via telegram bot
        message = f"Your reset OTP:"
        requests.get(f"""{TELEGRAM_API_URL}?chat_id={telegram_id}&text={message}""", timeout=5)
        # # debug(f"response : {response.text}")
        #
        requests.get(f"""{TELEGRAM_API_URL}?chat_id={telegram_id}&text={reset_otp}""", timeout=5)
        # # debug(f"response : {response.text}")

        return "reset otp sent"
    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/reset", deprecated=0)
async def _(
    telegram_id: str = Form(..., json_schema_extra={"example": ""}),
    reset_otp: str = Form(..., json_schema_extra={"example": ""}),
    username: str = Form(..., json_schema_extra={"example": ""}),
    password: str = Form(..., json_schema_extra={"example": ""}),
):
    try:

        # validate telegram_id and reset_otp
        query = {"telegram_id": telegram_id, "reset_otp": reset_otp}
        # debug(f"query : {query}")

        exist = await db.c_credential_reset_otp.find_one(query)
        if not exist:
            return Response(status_code=status.HTTP_400_BAD_REQUEST)
        # debug(f"exist : {exist}")

        user_id = exist["user_id"]

        # clear reset otp record after successful validation
        await db.c_credential_reset_otp.delete_one({"user_id": user_id})

        # update new password_hash
        await db.c_credential.update_one(
            {"_id": user_id},
            {
                "$set": {
                    "username": username,
                    "password_hash": se.to_hash(password),
                    "updated_at": datetime.now(),
                }
            },
        )

        # debug("username and password reseted")

        return 1
    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/read", deprecated=0)
async def _(
    token: str = Depends(oa),
):
    try:

        user = await db.c_credential.find_one({"token": token})
        if not user:
            return Response(status_code=status.HTTP_401_UNAUTHORIZED)

        return json.loads(json_util.dumps(user))

    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/update", deprecated=0)
async def _(
    token: str = Depends(oa),
    #
    id: Optional[str] = Form(None, json_schema_extra={"example": ""}),
    name: Optional[str] = Form(None, json_schema_extra={"example": ""}),
    phone_number: Optional[str] = Form(None, json_schema_extra={"example": ""}),
    email: Optional[str] = Form(None, json_schema_extra={"example": ""}),
    address: Optional[str] = Form(None, json_schema_extra={"example": ""}),
    #
    username: Optional[str] = Form(None, json_schema_extra={"example": ""}),
    password: Optional[str] = Form(None, json_schema_extra={"example": ""}),
    telegram_id: Optional[str] = Form(None, json_schema_extra={"example": ""}),
):
    try:

        user = await db.c_credential.find_one({"token": token})
        if not user:
            return Response(status_code=status.HTTP_401_UNAUTHORIZED)

        # # debug(f"user : {user}")

        if id is not None:
            await db.c_credential.update_one({"_id": user["_id"]}, {"$set": {"id": id, "updated_at": datetime.now()}}),

        if name is not None:
            await db.c_credential.update_one({"_id": user["_id"]}, {"$set": {"name": name, "updated_at": datetime.now()}}),

        if phone_number is not None:
            await db.c_credential.update_one({"_id": user["_id"]}, {"$set": {"phone_number": phone_number, "updated_at": datetime.now()}}),

        if email is not None:
            await db.c_credential.update_one({"_id": user["_id"]}, {"$set": {"email": email, "updated_at": datetime.now()}}),

        if address is not None:
            await db.c_credential.update_one({"_id": user["_id"]}, {"$set": {"address": address, "updated_at": datetime.now()}}),

        if username is not None:
            await db.c_credential.update_one({"_id": user["_id"]}, {"$set": {"username": username, "updated_at": datetime.now()}}),

        if password is not None:
            await db.c_credential.update_one({"_id": user["_id"]}, {"$set": {"password_hash": se.to_hash(password), "updated_at": datetime.now()}}),

        if telegram_id is not None:
            await db.c_credential.update_one({"_id": user["_id"]}, {"$set": {"telegram_id": telegram_id, "updated_at": datetime.now()}}),

        return 1

    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/upload", deprecated=0)
async def _(
    access_token: str = Depends(oa),
    profile_image: UploadFile | None = File(None),
    background_image: UploadFile | None = File(None),
):
    try:

        user = await db.c_credential.find_one({"token": access_token})
        if not user:
            return Response(status_code=status.HTTP_401_UNAUTHORIZED)
        # debug(user)

        if profile_image is not None:

            # *check image size max 5 MB
            content = await profile_image.read()
            # # debug(type(content))
            # # debug(f"file size : {len(content)} bytes")
            if len(content) > MAX_IMAGE_UPLOAD_SIZE or len(content) <= 0:
                return Response(status_code=status.HTTP_400_BAD_REQUEST)

            # *prepare image name and path
            now = datetime.now()
            # # debug(f"now : {now}")
            image_path = f"{now.year:04d}/{now.month:02d}/{now.day:02d}"
            # # debug(f"image_path : {image_path}")
            image_name = f"{now.strftime('%H%M%S%f')}_{tk.gen(8)}"
            # # debug(f"image_name : {image_name}")
            image_ext = profile_image.filename.split(".")[-1]
            # # debug(f"image_ext : {image_ext}")
            new_image_name = f"{image_path}/{image_name}.{image_ext}"
            # # debug(f"new_image_name : {new_image_name}")

            # *delete old image file if exists
            old_image_name = user.get("profile_image")
            # # debug(f"old_image_name : {old_image_name}")
            if old_image_name:
                if s3.object_exists(MINIO_BUCKET_PUBLIC, old_image_name):
                    s3.remove_object(MINIO_BUCKET_PUBLIC, old_image_name)

            # *upload new image file
            s3.put_object(
                bucket_name=MINIO_BUCKET_PUBLIC,  # bucket name
                object_name=new_image_name,  # file name in bucket
                data=BytesIO(content),  # file-like object
                length=len(content),  # size of the data in bytes
                part_size=10 * 1024 * 1024,  # 10 MB chunks
                content_type=profile_image.content_type,  # MIME type of the file
            )

            # *add image name to database
            await db.c_credential.update_one(
                {"_id": user["_id"]},
                {
                    "$set": {
                        "profile_image": new_image_name,
                        "updated_at": datetime.now(),
                    }
                },
            )

        if background_image is not None:

            # *check image size max 5 MB
            content = await background_image.read()
            # # debug(type(content))
            # # debug(f"file size : {len(content)} bytes")
            if len(content) > MAX_IMAGE_UPLOAD_SIZE or len(content) <= 0:
                return Response(status_code=status.HTTP_400_BAD_REQUEST)

            # *prepare image name and path
            now = datetime.now()
            # # debug(f"now : {now}")
            image_path = f"{now.year:04d}/{now.month:02d}/{now.day:02d}"
            # # debug(f"image_path : {image_path}")
            image_name = f"{now.strftime('%H%M%S%f')}_{tk.gen(8)}"
            # # debug(f"image_name : {image_name}")
            image_ext = background_image.filename.split(".")[-1]
            # # debug(f"image_ext : {image_ext}")
            new_image_name = f"{image_path}/{image_name}.{image_ext}"
            # # debug(f"new_image_name : {new_image_name}")

            # *delete old image file if exists
            old_image_name = user.get("background_image")
            # # debug(f"old_image_name : {old_image_name}")
            if old_image_name:
                if s3.object_exists(MINIO_BUCKET_PUBLIC, old_image_name):
                    s3.remove_object(MINIO_BUCKET_PUBLIC, old_image_name)

            # *upload new image file
            s3.put_object(
                bucket_name=MINIO_BUCKET_PUBLIC,  # bucket name
                object_name=new_image_name,  # file name in bucket
                data=BytesIO(content),  # file-like object
                length=len(content),  # size of the data in bytes
                part_size=10 * 1024 * 1024,  # 10 MB chunks
                content_type=background_image.content_type,  # MIME type of the file
            )

            # *add image name to database
            await db.c_credential.update_one(
                {"_id": user["_id"]},
                {
                    "$set": {
                        "background_image": new_image_name,
                        "updated_at": datetime.now(),
                    }
                },
            )

        return "updated"

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/delete", deprecated=1)
async def _():
    try:

        return 1

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


if __name__ == "__main__":
    os.system("python sources_application/Run.py")
