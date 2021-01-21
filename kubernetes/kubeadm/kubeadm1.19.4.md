### 所有的节点都需要执行以下的步骤

systemctl stop firewalld
systemctl disable firewalld

sed -i 's/enforcing/disabled/' /etc/selinux/config
setenforce 0

swapoff -a
sed -i '/swap/d' /etc/fstab

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# sudo yum-config-manager --add-repo \
#   https://download.docker.com/linux/centos/docker-ce.repo

sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

sudo yum update -y && sudo yum install -y \
  containerd.io-1.2.13 \
  docker-ce-19.03.11 \
  docker-ce-cli-19.03.11

sudo mkdir /etc/docker

cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d

sudo systemctl daemon-reload
sudo systemctl restart docker

sudo systemctl enable docker


cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

sudo yum install -y kubelet-1.19.4 kubeadm-1.19.4 kubectl-1.19.4 --disableexcludes=kubernetes

sudo systemctl enable --now kubelet

---
### 只在master节点上执行以上步骤

kubeadm init --kubernetes-version=v1.19.4 --image-repository registry.aliyuncs.com/google_containers --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/16 --ignore-preflight-errors=Swap

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

curl https://docs.projectcalico.org/manifests/calico.yaml -O
kubectl apply -f calico.yaml

# - name: CALICO_IPV4POOL_CIDR
#   value: "192.168.0.0/16"
将这段注释打开 value值改成上面kubeadm命令中pod-network-cidr的值

kubectl taint node app-node node-role.kubernetes.io/master-
使k8s master-node可调度

---
### 在node节点上执行

将master上的config拷贝到目标服务器 $HOME/.kube/config 上。
kubeadm join 192.168.0.196:6443 --token nkkf8u.6togedoecr5shtgy \
    --discovery-token-ca-cert-hash sha256:a641ff9499341d7e2d025437bf6629f9a604a3c9976f19fbbe567732faeb965f


