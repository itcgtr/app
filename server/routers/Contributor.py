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


@router.post("/create", deprecated=0)
async def _():
    try:
        # Get the last document's index in a single query
        last_document = await db.c_contributor.find({}).sort("order", -1).limit(1).to_list(length=1)

        # Calculate new index: 1 if no documents exist, otherwise increment last index
        new_index = 1 if not last_document else last_document[0]["order"] + 1

        # Ensure the new_index is unique
        while await db.c_contributor.find_one({"order": new_index}):
            new_index += 1

        # insert new
        await db.c_contributor.insert_one(
            {
                "order": new_index,
                "name": "NAME",
                "position": "POSITION",
                "is_active": True,
                "created_at": datetime.now(),
            }
        )

        return 1

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/read", deprecated=0)
async def _():
    try:
        documents = await db.c_contributor.find({"is_active": True}).sort("order", 1).to_list(length=None)

        return json.loads(json_util.dumps(documents))

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/update", deprecated=0)
async def _(
    id: str = Form(None, json_schema_extra={"example": ""}),
    name: Optional[str] = Form(None, json_schema_extra={"example": ""}),
    position: Optional[str] = Form(None, json_schema_extra={"example": ""}),
    description: Optional[str] = Form(None, json_schema_extra={"example": ""}),
):
    try:

        doc = await db.c_contributor.find_one({"_id": ObjectId(id)})
        if not doc:
            return Response(status_code=status.HTTP_404_NOT_FOUND)

        if name is not None:
            await db.c_contributor.update_one({"_id": doc["_id"]}, {"$set": {"name": name, "updated_at": datetime.now()}})
            # await db.c_credential.update_one({"_id": user["_id"]}, {"$set": {"name": name, "updated_at": datetime.now()}}),

        if position is not None:
            await db.c_contributor.update_one({"_id": doc["_id"]}, {"$set": {"position": position, "updated_at": datetime.now()}})

        if description is not None:
            await db.c_contributor.update_one({"_id": doc["_id"]}, {"$set": {"description": description, "updated_at": datetime.now()}})

        return 1

    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/reorder", deprecated=0)
async def _(
    old_order: int = Form(...),
    new_order: int = Form(...),
):
    try:

        # debug(f"old_order : {old_order}")
        # debug(f"new_order: {new_order}")

        # Get the document to move
        doc_to_move = await db.c_contributor.find_one({"order": old_order})
        if not doc_to_move:
            return Response(status_code=status.HTTP_404_NOT_FOUND)

        if old_order < new_order:
            # Moving down: decrement indices of items between old and new position
            await db.c_contributor.update_many(
                {"order": {"$gt": old_order, "$lte": new_order}},
                {"$inc": {"order": -1}},
            )
        else:
            # Moving up: increment indices of items between new and old position
            await db.c_contributor.update_many(
                {"order": {"$gte": new_order, "$lt": old_order}},
                {"$inc": {"order": 1}},
            )

        # Update the moved document to its new position
        await db.c_contributor.update_one(
            {"_id": doc_to_move["_id"]},
            {"$set": {"order": new_order}},
        )

        return 1
    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/upload", deprecated=0)
async def _(
    id: str = Form(...),
    image: UploadFile = File(...),
):
    try:
        debug(id)

        doc = await db.c_contributor.find_one({"_id": ObjectId(id)})
        if not doc:
            return Response(status_code=status.HTTP_404_NOT_FOUND)

        # *check image size max 5 MB
        content = await image.read()
        if len(content) > MAX_IMAGE_UPLOAD_SIZE or len(content) <= 0:
            return Response(status_code=status.HTTP_400_BAD_REQUEST)

        # *prepare image name and path
        now = datetime.now()
        image_path = f"{now.year:04d}/{now.month:02d}/{now.day:02d}"
        image_name = f"{now.strftime('%H%M%S%f')}_{tk.gen(8)}"
        image_ext = image.filename.split(".")[-1]
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
            content_type=image.content_type,  # MIME type of the file
        )

        # *add image name to database
        await db.c_contributor.update_one(
            {"_id": doc["_id"]},
            {
                "$set": {
                    "image": new_image_name,
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
        doc = await db.c_contributor.find_one({"_id": ObjectId(id)})
        if not doc:
            return Response(status_code=status.HTTP_404_NOT_FOUND)

        await db.c_contributor.update_one(
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
    #
):
    try:
        return 1
    except Exception:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


if __name__ == "__main__":
    os.system("python sources_application/Run.py")
