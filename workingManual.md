
# common command used in shell script

1. extract the tar file
 ```sh
tar -xf /tmp/apache-tomcat.tar.gz -C "$INSTALL_DIR" --strip-components=1 
```
2. add newuser and group
```sh
useradd -m -g users zenoptics
```

3. sed, short for "Stream Editor," is a powerful text processing utility
```sh
sed "s/old/new/g" input_file
```
  
  eg:1
  ```sh
  sudo sed -e "s/\r//g" inputfile.properties > outputfile.properties //"s/old/new/g" here it is replacing with empty
  ```
      
  eg:2
  ```sh
  cmd="s+{JAVA_DIR}+$JAVA_HOME+g"  ```                                               //cmd="s+patten+replacement+g"
  sed -i "$cmd" /home/zenoptics/zenoptics/tomcat-config                              //edit within the file we use -i
  ```
  
  eg:3
  ```sh
  sudo sed -i "s/^SELINUX=enforcing$/SELINUX=permissive/" /etc/selinux/config        //^--->denotes starting of line & $ ---> ending
  ```
  
  eg:4
  ```sh
  cmd="s+{password}+${encrypted_pwd//+/\\+}+g"                                      //cmd="s+patten+${variable//pattern/replacement}+g"
  sed -i "$cmd" /opt/tomcat/tomcat9/conf/server.xml
  ```
  
  eg:5
  ```sh
  ncrypted_pwd="my+secret+password"
  escaped_pwd="${encrypted_pwd//+/\\+}"                                              //${variable//pattern/replacement}
  echo "$escaped_pwd"  //my\\+secret\\+password
  ```

note: * if we give nothing in new it is considered as empty 
      * g is global


4. download file in perticular folder and rename downloaded file
```sh
wget "$TOMCAT_URL" -O /tmp/apache-tomcat.tar.gz 
```

5. copying from windows to WSL
```sh
cp /mnt/d/Downloads/webapp.war /home/jaison/windowscp/
```


# common command usede in docker

1. To see container running
```sh
docker ps
```

2. To see the all the images in docker
```sh
docker images
```

3. To remove the container
```sh
docker rm <container id>
```

4. To delete the images
```sh
docker rmi <imageid>
```

5. stop the container 
```sh
docker stop <container id>
```

6. build image in docker
```sh
docker build --no-cache -t <imageNameToBuild> -f <dockerfileName> .
```

7. To run container on local machine
```sh
docker run -d -p 8080:8080 zen_tomcat
```

8. go inside container image
```sh
docker exec -it <containerId> /bin/bash
```

9. pull any images from docker hub
```sh
docker pull ubuntu:latest
```

10.remove all images except k8s
```sh
docker images | grep -v 'k8s' | awk '{print $3}' | xargs docker rmi
```

# common commands used in kubernetes

1. get the kubeconfig file content 
```sh
kubectl config view
```

2. to go inside terminal of container of pod
```sh
kubectl exec -i -t -n default <podName> -- sh -c "clear; (bash || ash || sh)"
```
                    or
```sh
kubectl exec -it <podName> -- /bin/bash
```

3. to get details of pod in wide
```sh
kubectl get pod -o wide
```

4. to get details of pod
```sh
kubectl describe pods <podName>
```

5. to port forward the services to local host
```sh
kubectl port-forward svc/docker-registry-frontend-service 8080:80
```

6. delete the deployment
```sh
kubectl delete deployment <deploymentName>
```

7. getting logs of pod
```sh
kubectl logs <podName>
```

8. getting logs if pod having multiple container running
```sh
kubectl logs <podName> -c <containerName>
```

9. applying the manifest file
```sh
kubectl apply -f <filename.yaml>
```

10. commonly used deployment syntax
```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

11. commonly used service syntax
```sh
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx 
  #type: NodePort
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 80
      #nodePort: 30080
```


# connect to a MySQL server installed on Windows from WSL, you can follow these steps:

1. Install MySQL Client in WSL: You can install the MySQL client in WSL using the following command:
```sh
sudo apt install mysql-client-core-8.0
```

2. Find IPv4 Address of WSL: (windows) 
* Start Menu --> settings --> Network & Internet --> advanced network settings --> hardware and connection properties -->
* In the list that appears, look for an item named vEthernet (WSL). The IPv4 address listed there is what you’ll use to connect to MySQL. eg: ipv4 address: 172.20.16.1/20

* **Knowlege note:** The IP address range 172.20.16.1/20 is a private IP address. It belongs to the private IP address space 172.16.0.0 - 172.31.255.255 (172.16.0.0/12). The IP address range 172.20.16.1/20 includes all IP addresses from 172.20.16.1 to 172.20.31.2543

3. execute below sql in sql cli: (Windows)
```sql
   CREATE USER 'root'@'172.20.28.153' IDENTIFIED BY 'rootroot'; --if error occus ok
   GRANT ALL PRIVILEGES ON *.* TO 'root'@'172.20.28.153';
   FLUSH PRIVILEGES;
```


4.Connect to MySQL from WSL: Now try to connect to MySQL from WSL using the following command:
```ssh
mysql -h 172.20.16.1 -P 3306 -u root -p

```

# To check number of tables in zenoptics you can execute below command

```sql
SELECT COUNT(*)FROM information_schema.tables WHERE table_schema = 'zenoptics';
```




