# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'win32ole'

file_system = WIN32OLE.new("Scripting.FileSystemObject")
drives      = file_system.Drives
playbook  = ENV['PLAYBOOK_OVERRIDE'] || "ansible/setup-docker.yml"
requirements = ENV['REQUIREMENTS_OVERRIDE'] || "ansible/requirements.yml"

Vagrant.configure("2") do |config|
  config.vm.box = 'geerlingguy/ubuntu1604'
  config.ssh.insert_key = false
  config.vbguest.auto_update = false
  config.vbguest.no_remote = true
  drives.each do |drive|
    if "#{drive.DriveType}" === "2"
      config.vm.synced_folder "#{drive.DriveLetter}:/", "/mnt/#{drive.DriveLetter.downcase}", :mount_options => ["rw"]
    end
  end
  config.vm.network :forwarded_port, guest: 22, host: 2222, host_ip: "127.0.0.1", id: "ssh"
  config.vm.network :forwarded_port, guest: 2375, host: 2375, host_ip: "127.0.0.1", id: "docker"
  config.vm.provider :virtualbox do |vb|
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
    ansible.galaxy_role_file  = requirements
    ansible.galaxy_roles_path = "/etc/ansible/roles"
    ansible.galaxy_command    = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
    ansible.playbook          = playbook
    ansible.inventory_path    = "ansible/hosts"
    ansible.limit             = "docker"
  end
end
