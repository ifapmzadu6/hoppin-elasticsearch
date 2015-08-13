#!/bin/bash


# sleep
sleep 15



obody='{
  "type" : "jdbc",
  "jdbc" : { 
    "url" : "jdbc:mysql://MYSQL_ADDR:3306/hoppin",
    "user" : "root",
    "password" : "MYSQL_PASSWORD",
    "sql" : "SELECT *, id as _id FROM actions",
    "schedule" : "0 0-59 0-23 ? * *",
    "index" : "hoppin",
    "type" : "actions"
  }   
}'
tbody=`echo "$obody" | sed -e "s/MYSQL_ADDR/$MYSQL_ADDR/"`
body=`echo "$tbody" | sed -e "s/MYSQL_PASSWORD/$MYSQL_PASSWORD/"`
echo "$body"
 

echo $JDBC_IMPORTER_HOME

# import
bin=$JDBC_IMPORTER_HOME/bin
lib=$JDBC_IMPORTER_HOME/lib

cd $JDBC_IMPORTER_HOME
echo "$body" | java \
       -cp "${lib}/*" \
       -Dlog4j.configurationFile=${bin}/log4j2.xml \
       org.xbib.tools.Runner \
       org.xbib.tools.JDBCImporter

