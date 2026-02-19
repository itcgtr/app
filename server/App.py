import os
import sys


sys.path.append(os.getcwd())


from fastapi import *
from fastapi.responses import *
from fastapi.staticfiles import *
from fastapi.middleware.cors import *

from server.Environment import *

from server.utilities.Storage import Storage

from server.routers import Home
from server.routers import Contributor
from server.routers import Credential
from server.routers import Attendance
from server.routers import Template


app = FastAPI(title=TITLE, version="1.0.0", docs_url="/")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])

s3 = Storage()

policy = f"""{{
    "Version": "2012-10-17",
    "Statement": [{{
        "Effect": "Allow",
        "Principal": {{"AWS": ["*"]}},
        "Action": ["s3:GetObject"],
        "Resource": ["arn:aws:s3:::{MINIO_BUCKET_PUBLIC}/*"]
    }}]
}}"""

s3.set_bucket_policy(MINIO_BUCKET_PUBLIC, policy)


app.include_router(Credential.router, prefix="/credential", tags=["Credential"])
app.include_router(Contributor.router, prefix="/contributor", tags=["Contributor"])
app.include_router(Attendance.router, prefix="/attendance", tags=["Attendance"])
app.include_router(Home.router, prefix="/home", tags=["Home"])
app.include_router(Template.router, prefix="/template", tags=["Template"])


if __name__ == "__main__":

    import os
    import uvicorn
    import webbrowser
    from threading import Timer

    module_name = os.path.relpath(os.path.abspath(__file__), os.getcwd()).replace("\\", ".").replace("/", ".")[:-3]
    variable_name = "app"

    def open_browser():
        webbrowser.open("http://127.0.0.1:8000")

    Timer(1, open_browser).start()

    uvicorn.run(
        f"{module_name}:{variable_name}",
        host="127.0.0.1",
        port=8000,
        reload=True,
        reload_includes=["server/**"],
        reload_excludes=["__pycache__"],
    )

# deploy cmd
# For production:
# uvicorn server.App:app --host 0.0.0.0 --port 8000 --workers 4
