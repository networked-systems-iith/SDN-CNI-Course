## Click here for [Minikube Installation](https://github.com/networked-systems-iith/SDN-CNI-Course/blob/main/minikube/minikube-installation.md)

## BookInfo Application Setup Procedure

### Download the Minikube Project Files from git

### Start the Minikube

`minikube start --driver=docker`

### Change the directory to bookinfo-app

```shell
cd bookinfo-app
```

### Deploy the Application

- Set the **MYHOST** environment variable to hold the URL of the application:
  ```shell
  export MYHOST=$(kubectl config view -o jsonpath={.contexts..namespace}).bookinfo.com
  ```

- Deploy the application using the bookinfo.yaml file
  ```shell
  kubectl create -f Deployment/details-deploy.yaml
  kubectl create -f Deployment/ratings-deploy.yaml
  kubectl create -f Deployment/reviews-deploy.yaml
  kubectl create -f Deployment/productpage-deploy.yaml

  kubectl create -f Service/details-svc.yaml
  kubectl create -f Service/ratings-svc.yaml
  kubectl create -f Service/reviews-svc.yaml
  kubectl create -f Service/productpage-svc.yaml
  ```

- Check the status of the pods, services
  ```shell
  kubectl get pods -A
  kubectl get deploy -A
  kubectl get svc -A
  ```
![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/9aad4b03-1d92-481a-87c5-dfb747109f5d)

![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/160362d8-5473-45df-a1da-aeceb21973d4)

![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/94cec70c-dc20-4f4b-ae05-16f1435913fd)


### Enable External Access to the Application

- Enable the access using bookinfo-ingress.yaml file
  ```shell
  kubectl create -f LoadBalancer/bookinfo-ingress.yaml
  ```

#### If you face the LoadBalancer deployment issue with $MYHOST, then follow the [fix here](https://github.com/networked-systems-iith/SDN-CNI-Course/issues/1)

### Update the /etc/hosts file in the linux based system for the URL to be accessed in the local

`sudo nano /etc/hosts`

```shell
IP-ADDRESS    default.bookinfo.com
```

### Access Your Application

```shell
echo http://$MYHOST/productpage
```

Copy the Output and Paste it in the browser along with the nodeport like the following:

[http://default.bookinfo.com:30075/productpage](http://default.bookinfo.com:30075/productpage)

![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/e6e788f7-696e-4c77-992e-042e567ae428)

### To Delete All the pods, services

`minikube delete --all`

