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
   
5. 
