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








