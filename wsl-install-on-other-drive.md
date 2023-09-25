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

