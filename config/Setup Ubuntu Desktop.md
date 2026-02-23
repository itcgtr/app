## 1. Setup Ubuntu Desktop

```sh

# goto super user mode
su

```

### Update and Install Necessary Packages

```sh

# update and upgrade packages
apt update && apt upgrade -y

# install necessary packages
apt install -y build-essential curl git vim htop net-tools


# install python3-venv if not installed
apt install python3-venv python3-pip -y

```

### Install SSH Server

```shell
# install openssh-server
apt install openssh-server -y

# configure ssh to allow port 22 an d
nano /etc/ssh/sshd_config

# uncomment and set the following lines:
# Port 22
# ListenAddress 0.0.0.0
# or use sed command:
sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config

# in windows:  remove ssh hostkey in window os
# del C:\Users\your_user\.ssh\known_hosts



# check ssh service status
systemctl enable ssh
systemctl start ssh
systemctl status ssh

systemctl daemon-reexec
systemctl daemon-reload
systemctl restart ssh


# ssh test connections
ssh ains@ains-pi
ssh gtr@gtr-server
ssh msl@msl-server


########## OPTIONAL ##########

#
-i

# add root password
passwd

# configure ssh to allow root login
nano /etc/ssh/sshd_config
# PermitRootLogin yes


# list all service
# systemctl list-units --type=service


# restart ssh service
systemctl daemon-reload
systemctl restart ssh
# or
systemctl daemon-reload
systemctl restart sshd

```

### Install Docker

```shell

# install docker
apt install docker.io -y


# reload docker service
systemctl daemon-reexec
systemctl daemon-reload

# enable docker service
systemctl enable docker
systemctl start docker
systemctl status docker




# list all docker containers
docker ps -a


docker stop mongo_7000
docker rm mongo_7000

docker stop mongo_developer
docker rm mongo_developer



cloudflared access tcp --hostname dev.codeshift.me --url 127.0.0.1:27018







```

### Install Tailscale

```shell
# update and upgrade system
apt-get update && apt-get upgrade -y


# install curl if not installed
apt-get install curl -y

# install tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# start tailscale with login
tailscale up

# NOTE: follow the URL to login to your tailscale account



# set tailscale service
systemctl enable tailscaled
systemctl start tailscaled
systemctl daemon-reload
systemctl status tailscaled


# install nmcli
apt-get install network-manager -y

# list wifi devices
nmcli device wifi list

# tailscale up --authkey tskey-auth-kTH63mEbZF11CNTRL-JWFpW6KEA3iB2eGUnnmK3iXhEobK5fdTS

```

### Install Cloudflare Tunnel

```shell

# Add cloudflare gpg key
mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

# Add this repo to your apt repositories
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared any main' | tee /etc/apt/sources.list.d/cloudflared.list

# install cloudflared
apt-get update && apt-get install cloudflared

# [OPTIONAL] uninstall existing cloudflared service (if any)
cloudflared service uninstall


# [SYNTAX]: install cloudflared service with access tcp
cloudflared service install [TOKEN_HERE]

# reload cloudflared
systemctl daemon-reexec
systemctl daemon-reload
systemctl restart cloudflared
systemctl status cloudflared



```
