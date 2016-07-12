from pyspark import SparkConf, SparkContext
import re

conf = SparkConf().setMaster("spark://192.168.56.100:7077").setAppName("My App")
sc = SparkContext(conf = conf)

sc.setLogLevel('WARN')

p = re.compile('^\d+\.\d+\.\d+\.\d+.*$')

input_file = sc.textFile('/etc/hosts')
hosts = input_file.filter(lambda x: p.match(x))

ips = hosts.map(lambda x: x.split('\t')[0])

print "\nnumber of ips: %d" % ips.count()
print '-'*5

for ip in ips.collect():
        print ip
