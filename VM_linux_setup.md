# steps to setup linux machine in virtual box
1. enable the password authentication
   ```
   sudo /etc/ssh/sshd_config
   ```
   * press ctrl + w and search **PasswordAuthentication** make it to **yes**
   ```
   systemctl restart sshd
   ```
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
   ```
