import os
import sys


sys.path.append(os.getcwd())


import json
from bson import json_util
from datetime import datetime

from fastapi import *
from fastapi.security import *


from server.Environment import *
from server.utilities.Database import Mongo_DB
from server.utilities.Debug import Debug
from server.routers import Credential

# from server.utilities.Debug import debug


router = APIRouter()

db = Mongo_DB()
oa = OAuth2PasswordBearer(tokenUrl="credential/signin")


# teacher enable attendance by generating a QR code
@router.post("/enable_qr_scan")
async def _(
    token: str = Depends(oa),
    class_name: str = Form(..., json_schema_extra={"example": ""}),
    class_type: str = Form(..., json_schema_extra={"example": ""}),
    code: str = Form(..., json_schema_extra={"example": ""}),  # this is code
):
    try:

        # print(token)
        # Validate the token
        user = await db.c_credential.find_one({"token": token})
        if not user:
            return Response(status_code=status.HTTP_401_UNAUTHORIZED)

        # check if the user is a teacher
        if user.get("role") != "teacher":
            return Response(status_code=status.HTTP_403_FORBIDDEN)

        # check if class_name exists
        class_info = await db.c_class_name.find_one({"class_name": class_name})
        if not class_info:
            return Response(status_code=status.HTTP_400_BAD_REQUEST)

        # check if class_type exists
        class_type_info = await db.c_class_type.find_one({"class_type": class_type})
        if not class_type_info:
            return Response(status_code=status.HTTP_400_BAD_REQUEST)

        # check if there is an existing active code for this teacher
        query = {"user_id": user["_id"], "class_name": class_name, "class_type": class_type}
        existing_code = await db.c_attendance_code.find_one(query)
        if existing_code:
            update = {
                "$set": {
                    "code": code,
                    "updated_at": datetime.now(),
                }
            }
            await db.c_attendance_code.update_one(query, update)
            return "QR updated"

        # insert new code
        data = {
            "user_id": user["_id"],
            "class_name": class_name,
            "class_type": class_type,
            "code": code,
            "created_at": datetime.now(),
        }

        await db.c_attendance_code.insert_one(data)

        return "QR enabled"

    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


# teacher disable attendance by removing the QR code
@router.post("/disable_qr_scan")
async def _(
    token: str = Depends(oa),
):
    try:
        # Validate the token
        user = await db.c_credential.find_one({"token": token})
        if not user:
            return Response(status_code=status.HTTP_401_UNAUTHORIZED)

        # check if the user is a teacher
        if user.get("role") != "teacher":
            return Response(status_code=status.HTTP_403_FORBIDDEN)

        await db.c_attendance_code.delete_many({"user_id": user["_id"]})

        return "QR disabled"

    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


# student scan for attendance
@router.post("/qr_scan")
async def _(
    token: str = Depends(oa),
    code: str = Form(..., json_schema_extra={"example": ""}),
):

    try:
        # check token validity
        user_info = await db.c_credential.find_one({"token": token})
        if not user_info:
            return Response(status_code=status.HTTP_401_UNAUTHORIZED)

        # check attendance code validity
        code_info = await db.c_attendance_code.find_one({"code": code})
        if not code_info:
            return Response(status_code=status.HTTP_400_BAD_REQUEST)

        class_name = code_info["class_name"]
        class_type = code_info["class_type"]
        # debug(code_info)

        class_info = await db.c_class_name.find_one({"class_name": class_name})
        class_type_info = await db.c_class_type.find_one({"class_type": class_type})

        # check if student already recorded attendance for this class in one hour
        student_record = await db.c_attendance.find_one(
            {
                "student_id": user_info["_id"],
                "class_id": class_info["_id"],
                "class_type_id": class_type_info["_id"],
            }
        )

        # debug(student_record)

        if student_record:
            time_diff = datetime.now() - student_record["recorded_at"]
            if time_diff.total_seconds() < 3600:  # 1 hour
                return "Attendance already recorded recently."

        # Record attendance
        data = {
            "teacher_id": code_info["user_id"],
            "student_id": user_info["_id"],
            "class_id": class_info["_id"],
            "class_type_id": class_type_info["_id"],
            "recorded_at": datetime.now(),
        }

        # record attendance in the database
        await db.c_attendance.insert_one(data)

        return "Attendance recorded successfully."

    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


# ok
@router.post("/class_names")
async def _():
    try:
        data = await db.c_class_name.find().to_list(10000)

        return json.loads(json_util.dumps(data))

    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


# ok
@router.post("/class_types")
async def _():
    try:
        data = await db.c_class_type.find().to_list(10000)
        return json.loads(json_util.dumps(data))
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


# ok
@router.post("/view")
async def _():
    try:
        data = await db.v_attendance.find().to_list(10000)
        return json.loads(json_util.dumps(data))

    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


if __name__ == "__main__":
    os.system("python server/App.py")
