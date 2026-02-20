import os
import sys


sys.path.append(os.getcwd())


from fastapi import *

from server.Environment import *
from server.utilities.Debug import Debug


router = APIRouter()


@router.post("/create")
async def _():
    try:
        x = 5
        y = x + 10
        z = y * 2

        Debug.debug()

        return 1
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/read")
async def _():
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/delete")
async def _(
    # id: str = Form(...)
):
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/update")
async def _(
    # id: str = Form(...)
):
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


@router.post("/upload")
async def _(
    # id: str = Form(...)
    # file: UploadFile = File(...),
):
    try:
        return True
    except Exception as e:
        return Response(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR)


if __name__ == "__main__":
    os.system("python server/App.py")
