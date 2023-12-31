wget -O splunkforwarder-9.1.2-b6b9c8185839.x86_64.rpm "https://download.splunk.com/products/universalforwarder/releases/9.1.2/linux/splunkforwarder-9.1.2-b6b9c8185839.x86_64.rpm"

rpm -i splunkforwarder-9.1.2-b6b9c8185839.x86_64.rpm


apt-get update
apt-get install wget
apt-get install curl
apt-get install netcat
apt-get install lsof

wget -O splunkforwarder-9.1.2-b6b9c8185839-linux-2.6-amd64.deb "https://download.splunk.com/products/universalforwarder/releases/9.1.2/linux/splunkforwarder-9.1.2-b6b9c8185839-linux-2.6-amd64.deb"

dpkg -i splunkforwarder-9.1.2-b6b9c8185839-linux-2.6-amd64.deb

--------through forwarder------------------

sudo yum install nc
nc -zv 192.168.40.237 9997
cd  /opt/splunkforwarder/bin
./splunk start
./splunk add monitor /var/log
./splunk add monitor /opt/tomcat/tomcat9/logs
cat /opt/splunkforwarder/etc/apps/search/local/inputs.conf
./splunk list monitor
./splunk add forward-server 192.168.40.237:9997 
cat /opt/splunkforwarder/etc/system/local/outputs.conf
./splunk list monitor
./splunk list forward-server
./splunk help list

-------through deployment app-----------------

sudo yum install nc
nc -zv  192.168.40.237 8089
cd  /opt/splunkforwarder/bin
./splunk start
./splunk set deploy-poll 192.168.40.237:8089
ls -l /opt/splunkforwarder/etc/apps/
./splunk restart

./splunk stop
kill -9 <pid>
./splunk start

cat /opt/splunkforwarder/etc/system/local/deploymentclient.conf
ls -l /opt/splunkforwarder/etc/apps/

-------debug---------------------------------

ip addr show
lsof -i -P -n | grep LISTEN
tail -f /opt/splunkforwarder/var/log/splunk/splunkd.log



Use the systemctl command with the list-units option and the type filter:

```
systemctl list-units --type=service --all
```
```
service --status-all
```
## Transferring file through ssh in powershell and linux shell

1. Folder
```
scp -r -P 2222 ZenOptics-LMY-1.1 ec2-user@127.0.0.1:~
```
2. file
```
scp -P 2222 ZenOptics-LMY-1.1.txt ec2-user@127.0.0.1:~
```
3. SSH to system (enable passwordauthenticatiom yes in /etc/ssh/sshd_config, reload sudo service sshd restart)
```
ssh ec2-user@127.0.0.1 -p 2222
```

## Installing the splunk enterprise

1. Download the rpm package from splunk enterprise download
```
wget -O splunk-9.1.2-b6b9c8185839.x86_64.rpm "https://download.splunk.com/products/splunk/releases/9.1.2/linux/splunk-9.1.2-b6b9c8185839.x86_64.rpm"
```
2. Unpack the downloaded package
```
sudo rpm -i splunk-9.1.2-b6b9c8185839.x86_64.rpm
```
3. change the default java
   
   ```
   wget https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.rpm
   ```
   ```
   sudo yum localinstall amazon-corretto-11-x64-linux-jdk.rpm -y
   ```
   ```
   sudo nano /opt/splunk/etc/splunk-launch.conf
   ```
   ```
   #java home

   JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto
   ```
3. accept the license and create user and password
```
sudo /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd Root@123 
```
4. Go browser and open **http://ipaddress:8000**
5. Enable the remote jmx
```
sudo nano /opt/tomcat/tomcat9/bin/setenv.sh
```
```
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.port=9000"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.ssl=false"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.authenticate=true"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.password.file=Root@123"
CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote.access.file=readwrite"
```
```
sudo systemctl restart tomcat
```
* username : ```jmxuser```
* password : ```Root@123```
* jmx url : ```service:jmx:rmi:///jndi/rmi://localhost:9000/jmxrmi```

7. Navigate to Find more apps and install
   * splunk add-on java managment extension
   * splunk add-on for tomcat
   * config explorer
     ```
     sudo mkdir /opt/splunk/etc/apps/config_explorer/local
     ```
     ```
     sudo nano /opt/splunk/etc/apps/config_explorer/local/config_explorer.conf
     ```
     ```
     [global]
     
     write_access = true
     hide_settings = false
     ```
  
### splunk add-on java managment extension
1. server -> add -> Name,jvm description,Connection type:url,username,password,server interval
### splunk add-on for tomcat
1. Account -> add -> Name,url,username,password -> add
2. 


## installing the splunk

1. Download the rpm package from splunk enterprise download
```
wget -O splunk-9.1.2-b6b9c8185839.x86_64.rpm "https://download.splunk.com/products/splunk/releases/9.1.2/linux/splunk-9.1.2-b6b9c8185839.x86_64.rpm"
```
2. Unpack the downloaded package
```
sudo rpm -i splunk-9.1.2-b6b9c8185839.x86_64.rpm
```
3. install
```
 sudo /opt/splunk/bin/splunk start --accept-license --answer-yes --no-prompt --seed-passwd Root@123
```

## Uninstalling the splunk

1. Stop Splunk Enterprise. You can do this by running the following command in your terminal:
```
sudo /opt/splunk/bin/splunk stop
```
2. Disable Splunk from starting at boot. You can do this by running the following command in your terminal:
```
sudo /opt/splunk/bin/splunk disable boot-start
```
3. Remove the Splunk package. You can do this by running the following command in your terminal:
```
sudo yum remove splunk -y
```
4. Find and kill any lingering processes that contain “splunk” in their name1.
```
kill -9 <pid>
```
6. Remove the Splunk Enterprise installation directory, $SPLUNK_HOME1.
```
sudo rm -rf /opt/splunk
```







