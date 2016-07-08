import sys
import json

def get_zk_url():
    with open('/vagrant/tmp/nodes.json') as f:
        nodes = json.load(f)
    for n in nodes:
        if 'master' in n['roles']:
            return "zk://%s:2181/mesos" % n['ip']
    return ''

if __name__ == "__main__":
    print get_zk_url()
