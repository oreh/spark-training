docker run \
	--name hive-metastore \
	--net  host \
	-v `pwd`/hive-site.xml:/usr/local/hive/conf/hive-site.xml \
        -e HADOOP_USER_CLASSPATH_FIRST=true \
	-it oreh/hive-metastore \
	sh -c 'bin/schematool -dbType mysql -initSchema && bin/hive --service metastore'
	#sh -c 'bin/hive --service metastore'
