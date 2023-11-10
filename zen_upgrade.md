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
* Replace above 2-8 line of sqlserver_data_congig.xml by
```
	<dataSource type="JdbcDataSource"
      driver="com.microsoft.sqlserver.jdbc.SQLServerDriver"
	    url="jdbc:sqlserver://{hostname}:{port};databaseName=zenoptics;encrypt=false;trustServerCertificate=true;"
	    user="{username}"
      password="{sslpassword}"
	    useSSL="false" 
      requireSSL="false" 
	    fallbackToSystemKeyStore="false" 
	    verifyServerCertificate="true"
	    encryptKeyFile="{encryptkeypath}\encryptKey.ini" />
	<document>
```
