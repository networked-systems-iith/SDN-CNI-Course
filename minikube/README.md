[Link](https://iith-my.sharepoint.com/:u:/g/personal/cs20resch11005_iith_ac_in/EdRzGSc_izRImaChIv8gM-IB7Wi-LrFITGdKLru5q7-7SA?e=nkOuFz) for the VM 

<!-- ## Click here for [Minikube Installation](https://github.com/networked-systems-iith/SDN-CNI-Course/blob/main/minikube/minikube-installation.md) -->

## BookInfo Application Setup Procedure

### Download the Minikube Project Files from git by downloading the zip file as shown below 
![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/80828013/e7088788-36fb-4d9b-8c77-09db40884b1b)

The zip file is downloaded in the Downloads folder --> Extract the zip file and proceed with the following steps.


### Start the Minikube

`minikube start --driver=docker`

![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/a5f275b9-aa2f-48de-a9e7-879b720fbeef)


### Change the directory to bookinfo-app

```shell
cd /Downloads/SDN-CNI-Course-main/minikube/bookinfo-app
```

![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/39c3688e-a457-4ac2-8e31-a8406e12803a)


### Update the /etc/hosts file in the linux based system for the URL to be accessed in the local

- Copy the IP of the cluster

  ```shell
  kubectl cluster-info
  ```

  ![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/0242404a-e425-4167-9c31-8e1a2a2a41b1)

- Paste the Copied Cluster IP in the /etc/hosts
  
  ```shell
  sudo nano /etc/hosts
  ```

    ```shell
  (IP-ADDRESS)    default.bookinfo.com
  ```
  
  ![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/e4693e1e-1149-424c-9324-739d38c68527)


### Deploy the Application

- Deployment of the application
  
  ```shell
  kubectl create -f Deployment/details-deploy.yaml
  ```
  ```shell
  kubectl create -f Deployment/ratings-deploy.yaml
  ```
  ```shell
  kubectl create -f Deployment/reviews-deploy.yaml
  ```
  ```shell
  kubectl create -f Deployment/productpage-deploy.yaml
  ```

  ![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/11f0be40-ec2e-4bff-968e-5492dc45c69c)

- Deploy the Services of the Application
  
  ```shell
  kubectl create -f Service/details-svc.yaml
  ```
  ```shell
  kubectl create -f Service/ratings-svc.yaml
  ```
  ```shell
  kubectl create -f Service/reviews-svc.yaml
  ```
  ```shell
  kubectl create -f Service/productpage-svc.yaml
  ```

  ![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/68013d1e-226f-43c2-a282-ae9d1a63a071)

- Check the status of the pods, services, deployment
  
  ```shell
  kubectl get pods -A
  ```
  ![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/9aad4b03-1d92-481a-87c5-dfb747109f5d)
  
  ```shell
  kubectl get deploy -A
  ```
  ![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/160362d8-5473-45df-a1da-aeceb21973d4)

  ```shell
  kubectl get svc -A
  ```
  ![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/94cec70c-dc20-4f4b-ae05-16f1435913fd)


### Enable External Access to the Application

- Enable the access using bookinfo-ingress.yaml file
  
  ```shell
  kubectl create -f LoadBalancer/bookinfo-ingress.yaml
  ```

  ![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/22f58a83-4533-4af0-8a96-f1a1a4824884)

- Check the bookinfo ingress
  
  ```shell
  kubectl get ingress bookinfo
  ```

  ![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/4ca6ad96-f7e8-4dc3-ae5d-c4e8137c4ac2)
  
### Access Your Application

[http://default.bookinfo.com:30075/productpage](http://default.bookinfo.com:30075/productpage)

![image](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/e6e788f7-696e-4c77-992e-042e567ae428)


## Appendix

- To Delete everything (i.e., pods, services, deploy etc.,)
  
  ```shell
  kubectl delete all --all
  ```

- To delete ingressbookinfo
  
  ```shell
  kubectl delete ingress bookinfo
  ```

- To delete the entire minikube cluster
  
  ```shell
  minikube delete --all
  ```
  ```shell
  minikube delete --purge
  ```
  
## References

- [Minikube Cheatsheet](https://cheat.readthedocs.io/en/latest/kubernetes/minikube.html)
- [Kubectl Cheatsheet Reference 1](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Kubectl Cheatsheet Reference 2](https://www.pluralsight.com/resources/blog/cloud/kubernetes-cheat-sheet)
- [Cheatsheet for Kubernetes Reference 1](https://medium.com/geekculture/cheatsheet-for-kubernetes-minikube-kubectl-5500ffd2f0d5)
- [Kubernetes Cheat Sheet Reference 2](https://intellipaat.com/blog/tutorial/devops-tutorial/kubernetes-cheat-sheet/)
- [Git Cheatsheet](https://github.com/networked-systems-iith/SDN-CNI-Course/assets/24610167/f8106909-4204-4042-a2a5-b58e65735852)
- [Linux Commands Cheatsheet](http://www.cheat-sheets.org/saved-copy/ubunturef.pdf)
