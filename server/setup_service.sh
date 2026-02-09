# update and install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install python3-venv python3-pip -y


########## __________ ##########

# create and activate a virtual environment
python3 -m venv .venv_application
source .venv_application/bin/activate

# install required python packages
pip install fastapi[all]
pip install uvicorn
pip install pillow
pip install pymongo
pip install minio
pip install requests
# pip install opencv-python-headless

########## __________ ##########

# create systemd service
SERVICE_NAME=gtr_application
WORKING_DIR=$(pwd)
SOURCE_DIR=$(pwd)/sources_application
# echo ${SERVICE_NAME}
# echo ${WORKING_DIR}
# echo ${SOURCE_DIR}

cat <<EOF | tee /etc/systemd/system/${SERVICE_NAME}.service > /dev/null
[Unit]
Description=${SERVICE_NAME}_service
After=network.target

[Service]
User=root
Type=simple
WorkingDirectory=${WORKING_DIR}
ExecStart=/bin/bash -c 'source ${WORKING_DIR}/.venv_application/bin/activate && python ${SOURCE_DIR}/Run.py'
StandardOutput=journal
StandardError=journal
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# start systemd
SERVICE_NAME=gtr_application
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable ${SERVICE_NAME}.service
systemctl start ${SERVICE_NAME}.service

# *[OPTIONAL] 
# check status
# SERVICE_NAME=gtr_application
# systemctl status ${SERVICE_NAME}.service

# ?[OPTIONAL] 
# restart service
# systemctl restart ${SERVICE_NAME}.service
# systemctl status ${SERVICE_NAME}.service

# ?[OPTIONAL] 
# stop service
# SERVICE_NAME=gtr_application
# systemctl stop ${SERVICE_NAME}.service
# systemctl disable ${SERVICE_NAME}.service


# ?[OPTIONAL] remove service
# SERVICE_NAME=gtr_application
# rm -rf /etc/systemd/system/${SERVICE_NAME}.service
# systemctl daemon-reload


########## CHECK PORT ##########

# show hosts file
# cat /etc/hosts

# [OPTIONAL] check what in port 8000
# lsof -i :9999

# [OPTIONAL] kill process in port 9999
# fuser -k 9999/tcp

# check
# cat /etc/systemd/system/${SERVICE_NAME}.service



