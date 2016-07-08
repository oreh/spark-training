# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

require 'json'
require "base64"
require 'fileutils'

FileUtils.mkdir_p 'tmp'

defaults = JSON.parse(File.read('./config/defaults.json'))
nodes = JSON.parse(File.read('nodes.json'))

node_list = Array.new(nodes.length)

nodes.length.times do |i|
    node_list[i] = defaults.clone()
    node_list[i].update(nodes[i])
end


# create hosts and inventory
host_contents = "127.0.0.1 localhost\n"\
    "\n"\
    "# The following lines are desirable for IPv6 capable hosts\n"\
    "::1 ip6-localhost ip6-loopback\n"\
    "fe00::0 ip6-localnet\n"\
    "ff00::0 ip6-mcastprefix\n"\
    "ff02::1 ip6-allnodes\n"\
    "ff02::2 ip6-allrouters\n"\
    "ff02::3 ip6-allhosts\n"\
    "\n"

inv_contents = "[default]\n"

nodes.length.times do |i|
    n = node_list[i]
    inv_contents += "%s\n" % [n['vm_name']]
    host_contents += "%s %s\n" % [n['ip'], n['vm_name']]
end

File.open("tmp/hosts","w") do |f|
    f.write(host_contents)
end

File.open("tmp/ansible_inventory","w") do |f|
    f.write(inv_contents)
end

File.open("tmp/nodes.json","w") do |f|
    f.puts nodes.to_json
end
## end /etc/hosts creation


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    node_list.each do |node|
        config.vm.define node['vm_name'] do |config|
            # -------------------- Box --------------------------------
            config.vm.box =  node['box']
            # ---------------------------------------------------------


            # -------------------- SSH --------------------------------
            config.ssh.username = node['username']
            if node['password'] != nil
                # vagrant will use password to connect to vms and insert
                # its insecure pub key to each of them
                config.ssh.password = node['password']
            elsif node['private_key_path'] != nil
                # Use our own key if it exists
                config.ssh.private_key_path = node['private_key_path']
            end
            # ---------------------------------------------------------


            # -------------------- Networks ---------------------------
            config.vm.hostname = node['hostname']

            if node['network'] == 'public'
                if node['ip'] != ""
                    config.vm.network :public_network, ip:node['ip']
                else
                    config.vm.network :public_network
                end
            elsif node['network'] == 'private'
                if node['ip'] != ""
                    config.vm.network :private_network, ip:node['ip']
                else
                    raise 'An ip must be given for private network'
                end
            else
                if node['network'] != "nat"
                    raise 'Unrecognized network mode: '+node['network']
                end

                if node['ip'] != ""
                    raise 'Can only assign ip when network mode is "public" or "private"'
                end
            end
           
                # --------------- Port Forwarding----------------------
            node['forward_ports'].each do |forward_port|
                config.vm.network "forwarded_port", guest: forward_port['guest'], host: forward_port['host']
            end
            # ---------------------------------------------------------


            # ------------------- VM Setup ----------------------------
            config.vm.provider :virtualbox do |vb|
                vb.gui = node['gui']
                vb.customize ["modifyvm", :id, "--memory", node['mem_size']]
                vb.customize ["modifyvm", :id, "--groups", node['vm_group']]
                vb.name = node['app_name'] + "-" + node['vm_name']
            end
            # ----------------------------------------------------------

            
            # ------------------- Provision ----------------------------
            config.vm.provision "shell", inline: "cd /vagrant/playbooks && ansible-playbook -b site.yml"
            #if node['provision_script'] != nil
            #    config.vm.provision "ansible_local" do |ansible|
            #        ansible.playbook = node['provision_script']
            #        ansible.sudo = true
            #        ansible.install = false
            #        ansible.provisioning_path = "/vagrant/playbooks"
            #    end
            #end
            # ----------------------------------------------------------

            
        end
    end
end
