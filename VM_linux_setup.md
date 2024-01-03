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
   ssh -o StrictHostKeyChecking=no ec2-user@192.168.1.41
   ```
   * in case warning occures @WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!@
   ```
   ssh-keygen -R 192.168.1.41
   ```
3. set the the static ip
   ```
   sudo nano /etc/sysconfig/network-scripts/ifcfg-eth0
   ```
   * paste below in file and save
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
   #!/bin/bash -x

   # Update the system
   yum update -y

   # Install OpenSSH server
   yum install openssh-server -y

   # Generate RSA key pair for root
   ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""

   # Set the correct permissions for root
   chmod 700 /root/.ssh

   # Move the public key to the authorized_keys file for root
   mv /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

   # Rename the private key to id.pem for root
   mv /root/.ssh/id_rsa /root/.ssh/id.pem

   # Get all users in the system
   for user in $(cut -d: -f1 /etc/passwd)
   do
       # Skip if the user does not have a home directory
       if [ ! -d "/home/$user" ]; then
           continue
       fi

       # Create .ssh directory for user if it does not exist
       mkdir -p /home/$user/.ssh

       # Copy the public key to the authorized_keys file for user
       cp /root/.ssh/authorized_keys /home/$user/.ssh/

       # Set the correct permissions for user
       chmod 700 /home/$user/.ssh
       chmod 600 /home/$user/.ssh/authorized_keys

       # Change the owner of the .ssh directory and authorized_keys file to the user
       chown -R $user: /home/$user/.ssh
   done

   # Disable password authentication
   echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

   # Enable public key authentication
   echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config

   # Restart the SSH service
   systemctl restart sshd
   
   ```
   * give the execution permission to file
   ```
   chmod +x pwdless_ssh.sh
   ```
   * execute the file
   ```
   ./pwdless_ssh.sh
   ```
   
5. copy the private key i.e **.pem** file which is same we have setted for root and other user in the system
   ```sh
   cat .ssh/id.pem
   ```
6. create a file called **amazonVM.pem** and copy above content to it.
7. Try to ssh by from powershell.
   ```sh
   ssh -i amazonVM.pem ec2-user@192.168.1.41
   ```
8. To ssh from putty convert **.pem** file to **.ppk** file 
   * **open PUTTYgen > click on load > navigate to .pem *(select AllFiles(*.*))* > click on save private key > give the file name > save**
9. now ssh using putty.
    * session
      * Host Name (or IP address) : ec2-user@192.168.1.41
      * Saved Sessions: ec2-user@192.168.1.41
    * Connection > SSH > Auth > Credentials > Private-key file for authentication: Browse the ppk file path.
    * Connection > SSH > Tunnels > source port: 8000(local machine port) > Destination: 192.168.1.41:8000(remote machine) > add
    * windows > appearance > click on change > Font: Consolas, Fontstyle: Regular, size: 16 > ok
    * session --> save
    * session select the saves session and open.

# Steps for file transfer

1. From host to remote
   ```
   scp -i C:/Users/LAPTOP-JAISON/amazonVM.pem -r -P 22 E:/MResultFinal/ZenOptics-LMY-1.1 ec2-user@192.168.1.41:~
   ```
2. Remote to host
   ```
   scp -i  C:/Users/LAPTOP-JAISON/amazonVM.pem -P 22 ec2-user@192.168.1.41:/home/ec2-user/splunk-new.zip C:/Users/LAPTOP-JAISON/Downloads
   ```
3. port tunneling to local host
   ```
   ssh -N -v -L 7091:127.0.0.1:7091 -L 7091:127.0.0.1:7091 ec2-user@192.168.1.41 -p 22
   ```
4. change the time zone
   ```
   sudo timedatectl set-timezone Asia/Kolkata
   ```

   
