import sys
import json

def has_role(name, role):
    with open('/vagrant/tmp/nodes.json') as f:
        nodes = json.load(f)
    return len(filter(lambda x: x['vm_name']==name and role in x['roles'], nodes))


if __name__ == "__main__":
    if has_role(sys.argv[1], sys.argv[2]):
        print 1
    else:
        print 0
