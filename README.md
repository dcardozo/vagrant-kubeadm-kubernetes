
# Vagrantfile and Scripts to Automate Kubernetes Setup using Kubeadm [Practice Environment for CKA/CKAD and CKS Exams]

## Fork Specific Details
This fork varies from the original repo as follows:
1. Vagrant box changed from "bento/ubuntu-22.04" to "debian/bullseye64"
2. CRI-O replaced by containerd
3. Calico deployed using Tigera Operators and Custom Resources
4. Kubernetes upgraded to 1.25.2

## Documentation

Current k8s version for CKA, CKAD and CKS exam: 1.24

Refer this link for documentation: https://devopscube.com/kubernetes-cluster-vagrant/

## 🚀 CKA, CKAD, CKS or KCNA Voucher Codes / Updates

If you are preparing for CKA, CKAD, CKS, or KCNA exam, **save 35%** today using code **DEVOPS35** at https://kube.promo/latest. It is a limited-time offer. Or Check out [Linux Foundation coupon](https://scriptcrunch.com/linux-foundation-coupon/) page for the latest voucher codes.

## Prerequisites

1. Working Vagrant setup
2. 8 Gig + RAM workstation as the Vms use 3 vCPUS and 4+ GB RAM

## For MAC/Linux Users

Latest version of Virtualbox for Mac/Linux can cause issues because you have to create/edit the /etc/vbox/networks.conf file and add:
<pre>* 0.0.0.0/0 ::/0</pre>

or run below commands

```shell
sudo mkdir -p /etc/vbox/
echo "* 0.0.0.0/0 ::/0" | sudo tee -a /etc/vbox/networks.conf
```

So that the host only networks can be in any range, not just 192.168.56.0/21 as described here:
https://discuss.hashicorp.com/t/vagrant-2-2-18-osx-11-6-cannot-create-private-network/30984/23

## Usage/Examples

To provision the cluster, execute the following commands.

```shell
git clone https://github.com/dcardozo/vagrant-kubeadm-kubernetes.git
cd vagrant-kubeadm-kubernetes
vagrant up
```

## Set Kubeconfig file variable

```shell
cd vagrant-kubeadm-kubernetes/configs
export KUBECONFIG=$(pwd)/config
```

or you can copy the config file to .kube directory. (_**Note**: This deletes previous contexts in ~/.kube/config; think twice!_)

```shell
cp config ~/.kube/
```

## Start Proxy Server
_Required if you want to access the dashboard._
```shell
kubectl proxy
```

## Kubernetes Dashboard URL

```shell
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=kubernetes-dashboard
```

## Kubernetes login token

Vagrant up will create the admin user token and saves in the configs directory.
Use this token to access the dashboard.

```shell
cd vagrant-kubeadm-kubernetes
cd configs
cat token
```

## To shutdown the cluster,

```shell
vagrant halt
```

## To restart the cluster,

```shell
vagrant up
```

## To destroy the cluster,

```shell
vagrant destroy -f
```

