# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'win32ole'

file_system = WIN32OLE.new("Scripting.FileSystemObject")
drives = file_system.Drives

# Plugins:
#   vagrant plugin install vagrant-vbguest
Vagrant.configure("2") do |config|
  config.vm.box = 'geerlingguy/ubuntu1604'
  config.ssh.insert_key = false
  config.vbguest.auto_update = false
  config.vbguest.no_remote = true
  drives.each do |drive|
    if "#{drive.DriveType}" === "2"
      config.vm.synced_folder "#{drive.DriveLetter}:/", "/mnt/#{drive.DriveLetter.downcase}", :mount_options => ["ro"]
    end
  end
  config.vm.network :forwarded_port, guest: 22, host: 2222, host_ip: "127.0.0.1", id: "ssh"
  config.vm.network :forwarded_port, guest: 2375, host: 2375, host_ip: "127.0.0.1", id: "docker"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  config.vm.provision "ansible_local" do |ansible|
    ansible.verbose        = false
    ansible.become = true
    ansible.galaxy_role_file = "ansible/requirements.yml"
    ansible.galaxy_roles_path = "/etc/ansible/roles"
    ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
    ansible.playbook       = "ansible/setup-docker.yml"
    ansible.inventory_path = "ansible/hosts"
    ansible.limit          = "docker"
  end
end
