
# create virtual environment
python -m venv .venv
.venv\Scripts\activate


# upgrade pip
python -m pip install --upgrade pip


# dependencies
pip install fastapi[all]
pip install uvicorn
pip install pillow
pip install pymongo
pip install minio
pip install requests
pip install python-telegram-bot


# development dependencies
pip install jupyter



