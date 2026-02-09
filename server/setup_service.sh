# create and activate a virtual environment
python -m venv .venv
./.venv/bin/activate

# install required python packages
pip install fastapi[all]
pip install uvicorn
pip install pillow
pip install pymongo
pip install minio
pip install requests
pip install jupyter


# pip install opencv-python-headless




