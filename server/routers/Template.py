import os
import sys


sys.path.append(os.getcwd())

from typing import *
from fastapi import *

import json
from io import BytesIO
from bson import json_util
from bson import ObjectId
from datetime import datetime

from Environment import *
from sources_application.utilities.Database import MongoDB
from sources_application.utilities.Token import Token
from sources_application.utilities.Storage import Storage
from sources_application.utilities.Debug import debug

router = APIRouter()

db = MongoDB()
s3 = Storage()
tk = Token()


# todo:
@router.post("/create", deprecated=0)
async def _():
    try:
        # use counter to solve the race condition problem
        counter = await db.c_counter.find_one_and_update(
            {"_id": "c_template"},
            {"$inc": {"seq": 1}},
            upsert=True,
            return_document=True,
        )

        await db.c_template.insert_one(
            {
                "order": counter["seq"],
                "data_1": "",
                "data_2": "",
                "is_active": True,
                "created_at": datetime.utcnow(),
            }
        )

        return 1

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


# todo: add limit and offset
@router.post("/read", deprecated=0)
async def _(
    # limit: int = Form(100, json_schema_extra={"example": 100}),
    # offset: int = Form(0, json_schema_extra={"example": 0}),
):
    try:
        documents = await db.c_template.find({"is_active": True}).sort("order", 1).limit(10000).to_list(length=10000)

        return json.loads(json_util.dumps(documents))

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


# todo: will implement later
@router.post("/pagination", deprecated=0)
async def _():
    try:
        # check total count of documents
        total_count = await db.c_template.count_documents({"is_active": True})
        return total_count

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/update", deprecated=0)
async def _(
    id: str = Form(..., json_schema_extra={"example": ""}),
    data_1: Optional[str] = Form(None, json_schema_extra={"example": ""}),
    data_2: Optional[str] = Form(None, json_schema_extra={"example": ""}),
):
    try:

        doc = await db.c_template.find_one({"_id": ObjectId(id)})
        if not doc:
            return Response(status_code=status.HTTP_404_NOT_FOUND)

        if data_1 is not None:
            await db.c_template.update_one({"_id": doc["_id"]}, {"$set": {"data_1": data_1, "updated_at": datetime.now()}})
            # await db.c_credential.update_one({"_id": user["_id"]}, {"$set": {"name": name, "updated_at": datetime.now()}}),

        if data_2 is not None:
            await db.c_template.update_one({"_id": doc["_id"]}, {"$set": {"data_2": data_2, "updated_at": datetime.now()}})

        return 1

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/reorder", deprecated=0, description="Reorder [1 to N]")
async def _(
    old_order: int = Form(...),
    new_order: int = Form(...),
):
    try:
        # Get the document to move
        doc_to_move = await db.c_template.find_one({"order": old_order})
        if not doc_to_move:
            return Response(status_code=status.HTTP_404_NOT_FOUND)

        # increase or decrease order of documents between old and new position
        if old_order < new_order:
            # Moving down: decrement indices of items between old and new position
            await db.c_template.update_many(
                {"order": {"$gt": old_order, "$lte": new_order}},
                {"$inc": {"order": -1}},
            )
        else:
            # Moving up: increment indices of items between new and old position
            await db.c_template.update_many(
                {"order": {"$gte": new_order, "$lt": old_order}},
                {"$inc": {"order": 1}},
            )

        # Update the moved document to its new position
        await db.c_template.update_one(
            {"_id": doc_to_move["_id"]},
            {"$set": {"order": new_order, "updated_at": datetime.now()}},
        )

        return 1
    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/upload", deprecated=0)
async def _(
    id: str = Form(...),
    image_1: Optional[UploadFile] = File(None),
    image_2: Optional[UploadFile] = File(None),
):
    try:
        debug(id)

        if image_1 is not None:
            doc = await db.c_template.find_one({"_id": ObjectId(id)})
            if not doc:
                return Response(status_code=status.HTTP_404_NOT_FOUND)

            # *check image size max 5 MB
            content = await image_1.read()
            if len(content) > MAX_IMAGE_UPLOAD_SIZE or len(content) <= 0:
                return Response(status_code=status.HTTP_400_BAD_REQUEST)

            # *prepare image name and path
            now = datetime.now()
            image_path = f"{now.year:04d}/{now.month:02d}/{now.day:02d}"
            image_name = f"{now.strftime('%H%M%S%f')}_{tk.gen(8)}"
            image_ext = image_1.filename.split(".")[-1]
            new_image_name = f"{image_path}/{image_name}.{image_ext}"
            debug(f"new_image_name : {new_image_name}")

            # *delete old image file if exists
            old_image_name = doc.get("image")
            debug(f"old_image_name : {old_image_name}")
            if old_image_name:
                if s3.object_exists(BUCKET_PUBLIC, old_image_name):
                    s3.remove_object(BUCKET_PUBLIC, old_image_name)

            # *upload new image file
            s3.put_object(
                bucket_name=BUCKET_PUBLIC,  # bucket name
                object_name=new_image_name,  # file name in bucket
                data=BytesIO(content),  # file-like object
                length=len(content),  # size of the data in bytes
                part_size=10 * 1024 * 1024,  # 10 MB chunks
                content_type=image_1.content_type,  # MIME type of the file
            )

            # *add image name to database
            await db.c_template.update_one(
                {"_id": doc["_id"]},
                {
                    "$set": {
                        "image_1": new_image_name,
                        "updated_at": datetime.now(),
                    }
                },
            )

        if image_2 is not None:
            doc = await db.c_template.find_one({"_id": ObjectId(id)})
            if not doc:
                return Response(status_code=status.HTTP_404_NOT_FOUND)

            # *check image size max 5 MB
            content = await image_2.read()
            if len(content) > MAX_IMAGE_UPLOAD_SIZE or len(content) <= 0:
                return Response(status_code=status.HTTP_400_BAD_REQUEST)

            # *prepare image name and path
            now = datetime.now()
            image_path = f"{now.year:04d}/{now.month:02d}/{now.day:02d}"
            image_name = f"{now.strftime('%H%M%S%f')}_{tk.gen(8)}"
            image_ext = image_2.filename.split(".")[-1]
            new_image_name = f"{image_path}/{image_name}.{image_ext}"
            debug(f"new_image_name : {new_image_name}")

            # *delete old image file if exists
            old_image_name = doc.get("image_2")
            debug(f"old_image_name : {old_image_name}")
            if old_image_name:
                if s3.object_exists(BUCKET_PUBLIC, old_image_name):
                    s3.remove_object(BUCKET_PUBLIC, old_image_name)

            # *upload new image file
            s3.put_object(
                bucket_name=BUCKET_PUBLIC,  # bucket name
                object_name=new_image_name,  # file name in bucket
                data=BytesIO(content),  # file-like object
                length=len(content),  # size of the data in bytes
                part_size=10 * 1024 * 1024,  # 10 MB chunks
                content_type=image_2.content_type,  # MIME type of the file
            )

            # *add image name to database
            await db.c_template.update_one(
                {"_id": doc["_id"]},
                {
                    "$set": {
                        "image_2": new_image_name,
                        "updated_at": datetime.now(),
                    }
                },
            )

        return 1

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/delete", deprecated=0)
async def _(
    id: str = Form(...),
):
    try:
        doc = await db.c_template.find_one({"_id": ObjectId(id)})
        if not doc:
            return Response(status_code=status.HTTP_404_NOT_FOUND)

        await db.c_template.update_one(
            {"_id": doc["_id"]},
            {
                "$set": {
                    "order": None,  # set order to None to avoid conflicts
                    "is_active": False,
                    "updated_at": datetime.now(),
                },
            },
        )

        return 1
    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/search", deprecated=1)
async def _(
    query: str = Form(..., json_schema_extra={"example": "search query"}),
):
    try:

        # search based on name
        results = (
            await db.c_template.find(
                {
                    "is_active": True,
                    "$or": [
                        {"name": {"$regex": query, "$options": "i"}},
                    ],
                }
            )
            .sort("order", 1)
            .limit(10000)
            .to_list(length=10000)
        )

        return json.loads(json_util.dumps(results))

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


if __name__ == "__main__":
    os.system("python sources_application/Run.py")
