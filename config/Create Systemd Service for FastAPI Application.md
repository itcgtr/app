## Create Systemd Service for FastAPI Application

```sh

# create systemd service file for gtr_backend
SERVICE_NAME=gtr_backend
WORKING_DIR=/root/gtr_app

cat <<EOF | tee /etc/systemd/system/${SERVICE_NAME}.service > /dev/null
[Unit]
Description=${SERVICE_NAME}_service
After=network.target

[Service]
User=root
Type=simple
WorkingDirectory=${WORKING_DIR}
ExecStart=/bin/bash -c 'source ${WORKING_DIR}/.venv/bin/activate && uvicorn server.App:app --host 127.0.0.1 --port 8000 --workers 4'
StandardOutput=journal
StandardError=journal
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# start systemd
systemctl daemon-reload
systemctl enable ${SERVICE_NAME}.service
systemctl start ${SERVICE_NAME}.service
systemctl status ${SERVICE_NAME}.service






# restart service
SERVICE_NAME=gtr_backend
systemctl restart ${SERVICE_NAME}.service
systemctl status ${SERVICE_NAME}.service


# stop service
SERVICE_NAME=gtr_backend
systemctl disable ${SERVICE_NAME}.service
systemctl stop ${SERVICE_NAME}.service
systemctl status ${SERVICE_NAME}.service


# [OPTIONAL] remove service
SERVICE_NAME=gtr_backend
rm -rf /etc/systemd/system/${SERVICE_NAME}.service
systemctl daemon-reload


# check port 8000
lsof -i :8000

# kill process in port 8000
fuser -k 8000/tcp


```
