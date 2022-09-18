set -e

usage() {
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo "sudo bash $0 <action> <os> <dataRoot>"
    echo "sudo bash $0 install centos /var/lib/docker"
    echo "sudo bash $0 install ubuntu /var/lib/docker"
    echo "sudo dockerd --debug"
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
}

script=$0
action=$1
os=$2
dataRoot=$3

if [[ ! ${action} ]]; then usage; exit 1; fi
if [[ ! ${os} ]]; then usage; exit 1; fi
if [[ ! ${dataRoot} ]]; then usage; exit 1; fi

function install_on_centos () {
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Reference"
echo "https://docs.docker.com/engine/install/centos/"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Uninstall old versions"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cat <<EOF
Older versions of Docker were called docker or docker-engine. 
If these are installed, uninstall them, along with associated dependencies.
EOF

sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Install"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
#sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Configuration"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

mkdir -p $(dirname /etc/docker/daemon.json)
if [[ -f /etc/docker/daemon.json ]]; then
    mv /etc/docker/daemon.json /etc/docker/daemon.json.$(date "+%Y-%m-%d-%H-%M-%S")
fi
echo '{"data-root":"'${dataRoot}'","registry-mirrors":["https://mirror.ccs.tencentyun.com","https://hub-mirror.c.163.com","https://reg-mirror.qiniu.com/"]}' > /etc/docker/daemon.json

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Verify"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

sudo systemctl daemon-reload    
sudo systemctl start docker
sudo docker run hello-world
}

function uninstall_on_centos () {

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Reference"
echo "https://docs.docker.com/engine/install/centos/"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Uninstall old versions"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cat <<EOF
Older versions of Docker were called docker or docker-engine. 
If these are installed, uninstall them, along with associated dependencies.
EOF

sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Uninstall"
echo "/var/lib/docker"
echo "/var/lib/containerd"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

sudo yum remove docker-ce docker-ce-cli containerd.io docker-compose-plugin
#sudo rm -rf /var/lib/docker
#sudo rm -rf /var/lib/containerd

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "You must delete any edited configuration files manually."
echo "/etc/docker/daemon.json"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"


}

function install_on_ubuntu () {
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Reference"
echo "https://www.runoob.com/docker/ubuntu-docker-install.html"
echo "https://docs.docker.com/engine/install/ubuntu/"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Uninstall old versions"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cat <<EOF
Older versions of Docker were called docker, docker.io, or docker-engine. 
If these are installed, uninstall them.
EOF

set +e
sudo apt-get remove docker docker-engine docker.io containerd runc
set -e

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Install"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

sudo apt-get update
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/ \
  $(lsb_release -cs) \
  stable"

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Configuration"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

sudo mkdir -p $(dirname /etc/docker/daemon.json)
if [[ -f /etc/docker/daemon.json ]]; then
    sudo mv /etc/docker/daemon.json /etc/docker/daemon.json.$(date "+%Y-%m-%d-%H-%M-%S")
fi
sudo echo '{"data-root":"'${dataRoot}'","registry-mirrors":["https://mirror.ccs.tencentyun.com","https://hub-mirror.c.163.com","https://reg-mirror.qiniu.com/"]}' > /etc/docker/daemon.json

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Verify"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

sudo systemctl daemon-reload    
sudo systemctl start docker
sudo docker run hello-world
}

function uninstall_on_ubuntu () {

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Reference"
echo "https://www.runoob.com/docker/ubuntu-docker-install.html"
echo "https://docs.docker.com/engine/install/ubuntu/"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Uninstall old versions"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
cat <<EOF
Older versions of Docker were called docker, docker.io, or docker-engine. 
If these are installed, uninstall them.
EOF
sudo apt-get update
set +e
sudo apt-get remove docker docker-engine docker.io containerd runc
set -e

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "Uninstall"
echo "/var/lib/docker"
echo "/var/lib/containerd"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

set +e
sudo apt-get remove -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
set -e
#sudo rm -rf /var/lib/docker
#sudo rm -rf /var/lib/containerd

echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
echo "You must delete any edited configuration files manually."
echo "/etc/docker/daemon.json"
echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

}



case ${action}_on_${os} in
    'install_on_centos') install_on_centos; ;;
    'install_on_ubuntu') install_on_ubuntu; ;;
    'uninstall_on_ubuntu') install_on_ubuntu; ;;
    'uninstall_on_ubuntu') install_on_ubuntu; ;;
    *) echo "Unknown CMD"; ;;
esac
