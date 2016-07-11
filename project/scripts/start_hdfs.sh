docker run -d \
	--net=host \
	-e MASTER=192.168.56.100 \
	oreh/hdfs:2.6.4 \
	sh -c 'hdfs namenode -format && hdfs namenode'

docker run -d \
	--net=host \
	-e MASTER=192.168.56.100 \
	oreh/hdfs:2.6.4 \
	sh -c 'hdfs datanode'
