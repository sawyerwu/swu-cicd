### 所有的节点都需要执行以下的步骤
swapoff -a
sed -i '/swap/d' /etc/fstab

apt-get update && sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y

curl -fsSL https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu/gpg | sudo apt-key add

add-apt-repository "deb [arch=amd64] https://mirrors.ustc.edu.cn/docker-ce/linux/ubuntu $(lsb_release -cs) stable"

apt-get update

apt-get install -y docker.io

apt update && sudo apt install -y apt-transport-https curl

curl -s https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -

echo "deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" >>/etc/apt/sources.list.d/kubernetes.list

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl enable docker

sudo apt update


sudo apt install -y kubelet=1.20.0-00 kubeadm=1.20.0-00 kubectl=1.20.0-00

sudo systemctl enable --now kubelet

---
### 只在master节点上执行以上步骤

kubeadm init --kubernetes-version=v1.20.0 --image-repository registry.aliyuncs.com/google_containers --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/16 --ignore-preflight-errors=Swap

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


mkdir -p $HOME/.kube
// copy $HOME/.kube/config from master to node
sudo chown $(id -u):$(id -g) $HOME/.kube/config

---

yum install bash-completion -y
source /usr/share/bash-completion/bash_completion
source <(kubectl completion bash)