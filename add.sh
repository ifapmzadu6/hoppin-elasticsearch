#!/bin/sh

obody='{
  "type" : "jdbc",
  "jdbc" : { 
    "url" : "jdbc:mysql://MYSQL_ADDR:3306/hoppin",
    "user" : "root",
    "password" : "MYSQL_PASSWORD",
    "schedule" : "0 0-59 0-23 ? * *",
    "sql" : "SELECT * FROM \"actions\""
  }   
}'

tbody=`echo $obody | sed -e "s/MYSQL_ADDR/$MYSQL_ADDR/"`
body=`echo $tbody | sed -e "s/MYSQL_PASSWORD/$MYSQL_PASSWORD/"`

curl -XPUT http://localhost:9200/_river/my_jdbc_river/_meta -d "$body"

