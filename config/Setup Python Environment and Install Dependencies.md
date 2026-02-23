## Setup Python Environment and Install Dependencies

```sh


# cd to project directory
cd /root/gtr_app


# create and activate a virtual environment
python3 -m venv .venv
source .venv/bin/activate


pip install fastapi[all]
pip install uvicorn
pip install pymongo
pip install minio
pip install requests

pip install pillow
pip install matplotlib
pip install python-telegram-bot

#
pip install opencv-python-headless
pip install insightface
pip install onnxruntime


# development dependencies
pip install jupyter
pip install ipdb



```
