1. list all listening port
```
netstat -a -n -b | findstr LISTENING
```
2. open the port
```
New-NetFirewallRule -DisplayName "Allow Port 8089" -Direction Inbound -LocalPort 8089 -Protocol TCP -Action Allow
```
3. list ip address
```
ipconfig
```
4. test the connection
```
Test-NetConnection -ComputerName 192.168.40.237 -Port 8089
```
