## BookInfo Application Setup Procedure


### Deploy the Application

- Set the **MYHOST** environment variable to hold the URL of the application:
  ```shell
  export MYHOST=$(kubectl config view -o jsonpath={.contexts..namespace}).bookinfo.com
  ```

- Deploy the application using the bookinfo.yaml file
  ```shell
  kubectl create -f bookinfo.yaml
  ```

- Check the status of the pods, services
  ```shell
  kubectl get pods -A
  kubectl get svc -A
  ```

- Scale the deployement after all the pods are in RUNNING state.
  ```shell
  kubectl scale deployment details-v1 --replicas 3

  kubectl scale deployment productpage-v1 --replicas 3

  kubectl scale deployment ratings-v1 --replicas 3

  kubectl scale deployment reviews-v1 --replicas 3
  ```

### Enable External Access to the Application

- Enable the access using bookinfo-ingress.yaml file
  ```shell
  kubectl create -f bookinfo-ingress.yaml
  ```

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

