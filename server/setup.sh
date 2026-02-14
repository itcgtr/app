
# update and upgrade packages
sudo apt update && sudo apt upgrade -y


# install docker
sudo apt install docker.io -y

# create virtual environment
python -m venv .venv
.venv\Scripts\activate


# create virtual environment for wsl
python3 -m venv .venv_wsl
source .venv_wsl/bin/activate

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



