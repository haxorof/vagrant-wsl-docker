# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'win32ole'
require 'yaml'

file_system = WIN32OLE.new("Scripting.FileSystemObject")
drives      = file_system.Drives

current_dir = File.dirname(File.expand_path(__FILE__))
default_config_file = "#{current_dir}/default-config.yml"
user_config_file = "#{current_dir}/user-config.yml"
yaml_config = YAML.load_file(default_config_file)
if File.file?(user_config_file)
  user_config = YAML.load_file(user_config_file)
  yaml_config.merge!(user_config)
end

if yaml_config.key?("vagrant_host_only_adapter_name")
  vbox_adapter = yaml_config['vagrant_host_only_adapter_name']
else
  if Gem.win_platform?
    vbox_adapter = 'VirtualBox Host-Only Ethernet Adapter'
  else
    vbox_adapter = 'vboxnet0'
  end
end

Vagrant.configure("2") do |config|
  if yaml_config.key?("vm_box_url")
    config.vm.box = yaml_config['vm_box_url']
  end
  config.vm.box = yaml_config['vm_box']
  config.ssh.insert_key = false
  config.vbguest.auto_update = true
  config.vbguest.no_remote = true
  drives.each do |drive|
    if "#{drive.DriveType}" === "2"
      config.vm.synced_folder "#{drive.DriveLetter}:/", "/mnt/#{drive.DriveLetter.downcase}", :mount_options => ["rw"]
    end
  end
  config.vm.network :forwarded_port, guest: 22, host: 2222, host_ip: "127.0.0.1", id: "ssh"
  config.vm.network :forwarded_port, guest: 2375, host: 2375, host_ip: "127.0.0.1", id: "docker"
  if "#{yaml_config['vagrant_use_host_only']}" === "1"
    config.vm.network "private_network", name: vbox_adapter,
      ip: yaml_config['vagrant_host_only_ip'], netmask: yaml_config['vagrant_host_only_netmask'], adapter: yaml_config['vagrant_host_only_adapter']
  end
  config.vm.provider :virtualbox do |vb|
    vb.name = "vagrant-wsl-docker"
    host = RbConfig::CONFIG['host_os']
    mem_divisor = 4 # Allocate 1/4 host memory
    cpu_divisor = 2 # Allocated 1/2 host logical processors

    if host =~ /darwin|bsd/
      cpus = `sysctl -n hw.ncpu`.to_i
      mem = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / mem_divisor
    elsif host =~ /linux/
      cpus = `nproc`.to_i
      mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / mem_divisor
    elsif host =~ /mswin|mingw/
      cpus = `wmic CPU Get NumberOfLogicalProcessors /Value`.strip.split('=')[1].to_i
      mem = `wmic ComputerSystem Get TotalPhysicalMemory /Value`.strip.split('=')[1].to_i / 1024 / 1024 / mem_divisor
    else
      cpus = 1
      mem = 1024
    end

    if cpus > 1
      cpus = cpus / cpu_divisor
    end

    vb.customize ["modifyvm", :id, "--memory", mem]
    vb.customize ["modifyvm", :id, "--cpus", cpus]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.provision "ansible_local" do |ansible|
    ansible.verbose           = false
    ansible.become            = true
    ansible.galaxy_role_file  = yaml_config['ansible_requirements']
    ansible.galaxy_roles_path = "/etc/ansible/roles"
    ansible.galaxy_command    = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
    ansible.playbook          = yaml_config['ansible_playbook']
    ansible.inventory_path    = "ansible/hosts"
    ansible.limit             = "docker"
  end
end
