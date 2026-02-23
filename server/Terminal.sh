# chmod +x server/Terminal.sh

# ssh root@gtr-server


cd /root/gtr_app

# github pull
git pull
# git pull origin main


# live log
SERVICE_NAME=gtr_backend
sudo systemctl restart ${SERVICE_NAME}.service
journalctl -u ${SERVICE_NAME} -f -o short-iso
