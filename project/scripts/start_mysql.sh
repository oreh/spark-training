#!/bin/sh
name=metastore-mysql
docker run \
  --name ${name} \
  -m 256m \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD=metastore \
  -e MYSQL_DATABASE=metastore \
  -e MYSQL_USER=hive \
  -e MYSQL_PASSWORD=hive \
  -d mysql


#docker exec ${name} sh -c 'mysql -h localhost -uroot -pmetastore -D metastore < /hive-schema-1.2.0.mysql.sql'
