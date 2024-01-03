# steps to setup linux machine in virtual box
1. enable the password authentication
   ```
   sudo nano /etc/ssh/sshd_config
   ```
   * press ctrl + w and search **PasswordAuthentication** make it to **yes** and save.
   * to apply restart the service by, 
   ```
   systemctl restart sshd
   ```
   * note the ip for ssh
   ```
   ifconfig
   ```
2. connect to it by ssh from *powershell*
   ```
   ssh -o StrictHostKeyChecking=no ec2-user@<ip addr>
   ```
   * in case warning occures @WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!@
   ```
   ssh-keygen -R <ip address>
   ```
3. set the the static ip
   ```
   sudo nano /etc/sysconfig/network-scripts/ifcfg-eth0
   ```
   * paste below in file
   ```
   DEVICE=eth0
   BOOTPROTO=static
   ONBOOT=yes
   IPADDR=192.168.1.41
   NETMASK=255.255.255.0
   GATEWAY=192.168.1.200
   ```
   * restart the service to apply
   ```
   sudo systemctl restart network
   ```
4. enable the passwordless authentication
   * switch to root
   ```
   sudo su -
   ```
   * create a file **pwdless_ssh.sh**
   ```
   nano pwdless_ssh.sh
   ```
   * paste the below script to file
   ```sh
   
   ```
