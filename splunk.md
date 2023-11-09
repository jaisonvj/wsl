# SPL COMMANDS [Click here](https://docs.splunk.com/Documentation/Splunk/9.1.1/SearchReference/ListOfSearchCommands)
1.
![image1](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-09%20122633.png)

pattern:
```
82.56%	Thu timestampmailsv1 sshd[5276]: Failed password for invalid user appserver from 194.8.74.23 port 3351 ssh2
1.7%	Thu timestampmailsv1 sshd[93483]: Server listening on :: port 22.
0.85%	Thu timestampmailsv1 sudo: djohnson ; TTY=pts/0 ; PWD=/home/djohnson ; USER=root ; COMMAND=/bin/su
```
* stats --> Calculates aggregate statistics, such as average, count, and sum, over the results set.
```
source="secure.log" action=failure
```
```
source="secure. log" action=failure | stats count by src
```
* iplocation --> Extracts location information from IP addresses by using 3rd-party databases. This command supports IPv4 and IPv6.where extra filed will be added
```
source="secure. log" action=failure | Iplocation src
```
* geostats --> command is used to generate statistics to display geographic data and summarize the data on maps.
  The command generates statistics which are clustered into geographical bins to be rendered on a world map.
```
source="secure. log" action=failure | iplocation sre | geostats count by Country
```
  

