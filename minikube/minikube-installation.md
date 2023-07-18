## Minikube Installation Steps

### Update and Upgrade your system

```shell
apt-get update -y && apt-get upgrade -y
```

### Installtion of Docker => Container Manager

```shell
sudo apt-get install ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker $USER && newgrp docker
```

To verify the docker installation run: `sudo docker run hello-world`

![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/77440140-f084-4605-808e-d96544c2b654)



### Minikube installation

```shell
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

minikube start --driver=docker
```

![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/bb28c36c-1a1c-4800-991c-2c6d04144b56)


### To make the docker default driver run

`minikube config set driver docker`

### Example to interact with your kubernetes cluster

`kubectl get po -A`

![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/a760fecb-da72-4268-866a-18fa8d6f0ade)

### To Delete Everything from minikube

`minikube delete all --all`

### References

1. [k8s Documentation](https://minikube.sigs.k8s.io/docs/start/)
