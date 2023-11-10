## 1) DB script:
* For online server dont change
* on-premisis:
  * Replace **ONLINE = ON** [3]
  ```
  ONLINE = OFF
  ```
  * Replace **DROP_EXISTING = ON** [3]
  ```
  DROP_EXISTING = OFF
  ```
* execute script in follwing order
  * create database zenoptics
  * zenoptics_sqlserver_schema_script
  * zenoptics_sqlserver_create_script
  * zenoptics_sqlserver_insert_script
  * check the database created properly by
  ```
   SELECT COUNT(*)FROM information_schema.tables WHERE table_schema = 'zenoptics';
  ```
## 2) Utilities - file
* -->properties file-->quartz_sqlserver.properties
* Replace to template and copy to quartz.properties in zenoptics folder
* 11,12,13
```
org.quartz.dataSource.zenoptics.URL=jdbc:sqlserver://{hostname}:{port};databaseName=zenoptics;connectRetryCount=10;ConnectRetryInterval=5;encrypt=false;
org.quartz.dataSource.zenoptics.user={username}
org.quartz.dataSource.zenoptics.password=ENC{password}
```
* -->properties file-->zenoptics_sqlserver.properties
* Replace to template and copy to zenoptcs.properties in zenoptics folder
* 21,22,23 and 38
```
zenopticsUserGroup={zenuser}
zenopticsAdminGroup={zenadmin}
zenopticsBIStewardGroup={zenbisteward}
```
```
applicationBaseURL=http\://{apphost}\:{appport}/com.zenoptics.services/jaxrs
```
* -->properties file-->thumbnails.properties
* if any changes copy thumbnail.properties in zenoptics folder
## 3) Solr
* -->solr-->zenoptics_analytics_solr_core-->conf/*
* copy all files in conf paste to zenoptics-->synoptics_conf/
* edit **sqlserver_data_congig.xml** to template
* 2 - 8
```
	<dataSource type="JdbcDataSource"
            driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
            url="jdbc:sqlserver://{hostname}:{port};database=zenoptics;trustServerCertificate=true"
            user="{username}"
            password="{password}" 
            encryptKeyFile="{encryptkeypath}\encryptKey.ini" />
	<document>
```
* In **zenoptics/synoptics_conf/solrconfig.xml** search **sqlserver** and check line ```<str name="config">sqlserver-data-config.xml</str>``` is uncommented and ```<!-- <str name="config">mysql-data-config.xml</str> -->``` is commented
* For ssl copy **zenoptics/synoptics_conf/solrconfig.xml** to **zenoptics/sqlserver-data-config-syn.xml**
* Replace above 2-8 line of sqlserver_data_congig.xml by 2-12 below lines
```
	<dataSource type="JdbcDataSource"
            driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
            url="jdbc:sqlserver://{hostname}:{port};database=zenoptics;trustServerCertificate=true"
            user="{username}"
            password="{sslpassword}"
            useSSL="false"
            requireSSL="false" 
	    fallbackToSystemKeyStore="false" 
	    verifyServerCertificate="true"
            encryptKeyFile="{encryptkeypath}\encryptKey.ini" />
	<document>
```

* -->solr-->zenoptics_main_search_solr_core-->conf/*
* copy all files in conf paste to zenoptics-->zen_analytics_conf/
* edit **sqlserver_data_congig.xml** to template
* 2 - 8
```
	<dataSource type="JdbcDataSource"
            driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
            url="jdbc:sqlserver://{hostname}:{port};database=zenoptics;trustServerCertificate=true"
            user="{username}"
            password="{password}" 
            encryptKeyFile="{encryptkeypath}\encryptKey.ini" />
	<document>
```
* In **zenoptics/zen_analytics_conf/solrconfig.xml** search **sqlserver** and check line ```<str name="config">sqlserver-data-config.xml</str>``` is uncommented and ```<!-- <str name="config">mysql-data-config.xml</str> -->``` is commented
* For ssl copy **zenoptics/zen_analytics_conf/solrconfig.xml** to **zenoptics/sqlserver-data-config-zen.xml**
* Replace above 2-8 line of sqlserver_data_congig.xml by 2-12 below lines
```
	<dataSource type="JdbcDataSource"
            driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
            url="jdbc:sqlserver://{hostname}:{port};database=zenoptics;trustServerCertificate=true"
            user="{username}"
            password="{sslpassword}"
            useSSL="false"
            requireSSL="false" 
	    fallbackToSystemKeyStore="false" 
	    verifyServerCertificate="true"
            encryptKeyFile="{encryptkeypath}\encryptKey.ini" />
	<document>
```
## 4) package registry
* From gitlab copy **com.zenoptics.extractors-4.3.1.2.48807134.GA.war** to zenoptics folder
* From gitlab copy **com.zenoptics.services-4.3.1.2.48807134.GA.war** to zenoptics folder
## 5) update the chrom
* lattest GoogleChromeEnterpriseBundle64.zip [Click here](https://chromeenterprise.google/browser/download/#windows-tab)
* lattest chromedriver-win64.zip [Click here](https://googlechromelabs.github.io/chrome-for-testing/#stable)
## 6) last step to fallow
* zip **zenoptics** folder
* rename main folder i.e **ZenOptics-WSS-4.3.1.2.48807134.GA**
* inside input.ini change to new version i.e **extractors_war=com.zenoptics.extractors-4.3.1.2.48807134.GA.war** and **services_war=com.zenoptics.services-4.3.1.2.48807134.GA.war**
* give necessory parameter in input.ini to check
## 7) execution

![image1](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-10%20122801.png)
![image2](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-10%20123040.png)
![image3](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-10%20123320.png)

* open powershell as admin
```
cd C:\Users\Administrator\Downloads\ZenOptics-WSS-
```
```
Unblock-File *.ps1
```
```
.\clean-install.ps1
```
```
.\zenbundle.ps1
```
* tomcat on 8080
  
![image4](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-10%20125135.png)
* solr on 8983
  
![image5](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-10%20124809.png)

* ssl:
* check this line before execution in script
![image6](https://github.com/jaisonvj/wsl/blob/main/Screenshots/Screenshot%202023-11-10%20130330.png)
```
.\zenoptics-ssl-config.ps1
```
## 8) post deployment check
* menu --> Administration setting --> source connection details -->plus(add)
  * Connection Type : POWERBICLOUDV2
  * Connection Name : PBICloudV2
  * hostname: https://login.windows.net/535ab425-5c4d-4b58-9a3b|f1906e840b2/oauth2/token
  * Client ID :b5a3bdf5-3050-4661-a14d-45d809fd7fe6
  * Client secret: ppL8Q~vbul5sZdFTYes6QF7CWNKLNqfckoumpaj4
  * Publish After Extraction: Yes
  * Tenant id: 535ab425-5c4d-4b58-9a3b-f1906e8e40b2
  * workspace filter : Include:Vine_Linux_Testing (take only one bcz it take more time)
  * App filter : Vine_Linux_Testing
  * use generic user : No
  * Test connection
* menu --> Administration setting --> Report types --> search (powerbi) 
  * edit **PowerBI Service Report**
    * tick PBICloudV2
    	* Report Launch URL: https://app.powerbi.com/reportembed?reportId=
    	* Thumbnail Generation URL: https://app.powerbi.com/reportembed?reportId=
    * update
  * edit **PowerBI Service App Report**
    * tick PBICloudV2
    	* Report Launch URL: https://app.powerbi.com/reportembed?reportId=
    	* Thumbnail Generation URL: https://app.powerbi.com/reportembed?reportId=
    * update
  * edit **PowerBI Service Dashboard**
    * tick PBICloudV2
    	* Report Launch URL: https://app.powerbi.com/dashboardEmbed?dashboardId=
    	* Thumbnail Generation URL: https://app.powerbi.com/dashboardEmbed?dashboardId=
    * update
  * edit **PowerBI Service App Dashboard**
    * tick PBICloudV2
    	* Report Launch URL: https://app.powerbi.com/dashboardEmbed?dashboardId=
    	* Thumbnail Generation URL: https://app.powerbi.com/dashboardEmbed?dashboardId=
    * update
   * edit **PowerBI Service Apps**
    * tick PBICloudV2
      	* Report Launch URL: https://app.powerbi.com/groups/me/apps/
    	* Thumbnail Generation URL: https://app.powerbi.com/groups/me/apps/
    * update
* menu --> Administration setting --> Source Connection Details --> Click on Run Complete [>]
* Copy solr url *only* ```https://10.0.134.243:8984```
* 


