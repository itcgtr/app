########## __________ ##########


# create systemd service file for gtr_backend
SERVICE_NAME=gtr_backend
WORKING_DIR=/home/msl/gtr_backend

cat <<EOF | sudo tee /etc/systemd/system/${SERVICE_NAME}.service > /dev/null
[Unit]
Description=${SERVICE_NAME}_service
After=network.target

[Service]
User=root
Type=simple
WorkingDirectory=${WORKING_DIR}
ExecStart=/bin/bash -c 'source ${WORKING_DIR}/.venv/bin/activate && python run.py'
StandardOutput=journal
StandardError=journal
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


# start systemd
SERVICE_NAME=gtr_backend
sudo systemctl daemon-reload
sudo systemctl enable ${SERVICE_NAME}.service
sudo systemctl start ${SERVICE_NAME}.service
sudo systemctl status ${SERVICE_NAME}.service


# restart service
SERVICE_NAME=gtr_backend
sudo systemctl restart ${SERVICE_NAME}.service
sudo systemctl status ${SERVICE_NAME}.service


# stop service
SERVICE_NAME=gtr_backend
sudo systemctl stop ${SERVICE_NAME}.service
sudo systemctl disable ${SERVICE_NAME}.service
sudo systemctl status ${SERVICE_NAME}.service


# [OPTIONAL] remove service
SERVICE_NAME=service_gtr_app
sudo rm -rf /etc/systemd/system/${SERVICE_NAME}.service
sudo systemctl daemon-reload











########## LOG COMMAND ##########

# Live logs
SERVICE_NAME=gtr_backend
journalctl -u ${SERVICE_NAME} -f

# Today only
SERVICE_NAME=gtr_backend
journalctl -u ${SERVICE_NAME} --since today

# Last 100 lines
SERVICE_NAME=gtr_backend
journalctl -u ${SERVICE_NAME} -n 100

# With ISO timestamps
SERVICE_NAME=gtr_backend
journalctl -u ${SERVICE_NAME} -o short-iso


# save log to file
WORKING_DIR=/home/msl/gtr_backend
sudo mkdir -p ${WORKING_DIR}/logs
sudo touch ${WORKING_DIR}/logs/service.log
sudo journalctl -u ${SERVICE_NAME} -n 10000 -o short-iso > ${WORKING_DIR}/logs/service.log
# sudo journalctl -u ${SERVICE_NAME} -o short-iso > ${WORKING_DIR}/logs/service.log


########## CHECK PORT ##########

# [OPTIONAL] check what in port 8000
sudo lsof -i :9999

# [OPTIONAL] kill process in port 9999
sudo fuser -k 9999/tcp



# check
# cat /etc/systemd/system/${SERVICE_NAME}.service


########## __________ ##########



# list all user in ubuntu
cut -d: -f1 /etc/passwd