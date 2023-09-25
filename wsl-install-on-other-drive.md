# we can install WSL on a non-system drive like the F drive. Here are the steps:

1. **Enable WSL:** Open PowerShell as Administrator and run the following command to enable the WSL feature1:
```sh
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```
2. **Create a directory:** Substitute the drive on which you want WSL to be installed if not F2. In PowerShell, set your location to the F drive and create a directory for the installation23:
```sh
Set-Location F:
New-Item WSL -Type Directory
Set-Location .\\WSL
```
3. **Download the appx package:** Find the URL of the distribution you want to install in this list2. For example, for Ubuntu 22.04, use this link. Now, download the appx package23:
```sh
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2204 -OutFile Linux.appx -UseBasicParsing
```
4. **Unpack the package:** Make a backup and unpack23:
```sh
Copy-Item .\\Linux.appx .\\Linux.zip
Expand-Archive .\\Linux.zip
```
5. **Find and run the installer:** You should find a file named <distribution>.exe. Run that file, and the WSL distribution should be installed in the unpack folder of the other drive.
If you don’t see an executable, look for an .appx file that was just unpacked, that is the flavor you want, and unzip that
```sh
Set-Location .\\Linux
Add-AppxPackage .\\Ubuntu_2204.1.7.0_x64.appx
```

# Now open the ubuntu from the shortcut added in the menu

**note:** `the wsl should be installed from microsoft store and Have the Virtual Machine Platform optional component enabled` [ClickHereForInstructions](https://devblogs.microsoft.com/commandline/a-preview-of-wsl-in-the-microsoft-store-is-now-available/#how-to-install-and-use-wsl-in-the-microsoft-store) 

6.enableing the systemd by opening wsl.conf file with nano:
```sh
sudo nano /etc/wsl.conf
```
7.paste this and save by ctrl+s and ctrl+x
```sh
[boot]
systemd=true
```

# Now change the system hostname

8. navigate to host file and replacing the ip by name or other name by the name we required
```sh
sudo nano /etc/hosts
```
9.apply this and restart the terminal
```sh
sudo hostnamectl set-hostname ubuntuWSL 
```
# we may face issue in connecting to lens

### Windows Preparation

1. Ensure hypervisor functionality is enabled in BIOS.
   * Otherwise you will hit https://github.com/microsoft/WSL/issues/5363
   *lets shut down the wsl
```
wsl --shutdown
```

2. Launch a PowerShell prompt in Administrator mode [Win+X > Windows PowerShell (Admin)]

```
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
bcdedit /set hypervisorlaunchtype auto
```
3. Install the Linux kernel update package and install it
   * x86/x64 - https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
   * arm64 - https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_arm64.msi

5. Restart machine

4. Launch a PowerShell prompt in Administrator mode [Win+X > Windows PowerShell (Admin)]

```
wsl --set-default-version 2
```

5. Install Ubuntu Linux distribution of your choice from the Windows Store (not the one with the version in the names)

6. Verify WSL version is set correctly

```
wsl --list --verbose
```
7.set the default wsl

```
wsl --setdefault Ubuntu
```
