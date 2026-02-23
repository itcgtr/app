## Check Logs and Ports

```sh


SERVICE_NAME=gtr_backend
systemctl restart ${SERVICE_NAME}.service
journalctl -u ${SERVICE_NAME} -f -o short-iso

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
WORKING_DIR=/root/gtr_app
mkdir -p ${WORKING_DIR}/logs
touch ${WORKING_DIR}/logs/service.log
journalctl -u ${SERVICE_NAME} -n 10000 -o short-iso > ${WORKING_DIR}/logs/service.log
# journalctl -u ${SERVICE_NAME} -o short-iso > ${WORKING_DIR}/logs/service.log


########## CHECK PORT ##########

# [OPTIONAL] check what in port 8000
lsof -i :9999

# [OPTIONAL] kill process in port 9999
fuser -k 9999/tcp



# check
# cat /etc/systemd/system/${SERVICE_NAME}.service


########## __________ ##########



# list all user in ubuntu
cut -d: -f1 /etc/passwd
```
