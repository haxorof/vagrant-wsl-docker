# vagrant-wsl-docker

This repository will guide you how to setup `docker` command to be used directly from `bash` using Windows Subsystem for Linux (WSL1).

## Prerequisites

* VirtualBox installed in Windows
* Vagrant installed in Windows
* Plugin `vbguest` installed in vagrant: `vagrant plugin install vagrant-vbguest` (automatically installed via the `.vagrantplugins` file)

## How to set it up

Install `docker` client by running the following inside `bash`:

```console
wget -O docker-cli.tgz -q https://download.docker.com/linux/static/stable/x86_64/docker-24.0.5.tgz \
  && tar -zxf docker-cli.tgz docker/docker \
  && rm docker-cli.tgz \
  && sudo cp docker/docker /usr/local/bin/docker \
  && rm docker/docker && rmdir docker
```

Next is to append configuration to `~/.bashrc` for `docker` to use TCP instead of file:

```console
echo 'export DOCKER_HOST=tcp://127.0.0.1:2375' >> ~/.bashrc
source ~/.bashrc
```

Note! Since 18.09 it is also possible to access the Docker daemon via SSH:

```console
echo 'export DOCKER_HOST=ssh://vagrant@192.168.56.56' >> ~/.bashrc
source ~/.bashrc
```

Now when this is done the `docker`client is ready to go. It is now time to
setup the VM which hosts the Docker daemon.

This guide assume you have Vagrant installed in Windows and therefore it is
necessary for add an alias to `~/.bash_aliases` to make Linux use the Vagrant in Windows:

```console
echo "alias vagrant='vagrant.exe'" >> ~/.bash_aliases
```

Time to create the VM which hosts the Docker daemon and you do this by just
making sure your current working directory is in the root of this repository
and run the following:

**Important!** Ensure that IP range `192.168.56.1-192.168.56.255` is not used and handled by any DHCP in your network because
this is used for the `host-only` network adapter. If this IP range is in use please look into the `Advanced` section how
to change the configuration.

```console
vagrant up
```

After this point the VM is ready and the Docker daemon is started. Test the `docker` client by running the following command:

```console
docker info
```

## General usage tip

After the you have setup everything and run the `vagrant up` once then from that point you can start and stop the box by
explicitly specifying the ID. This ID can be found using the command `vagrant global-status`. Using the ID will allow you
to start, stop and reprovision the box from any location (you do not need to go to the directory of the Vagrantfile).

## Advanced

If you would like to override any configuration defined in [default-config.yml](default-config.yml) then this is possible by adding a new
file called `user-config.yml` in this directory (will be ignored by git). The easiest way to start modifying the configuration is to look
at [default-config.yml](default-config.yml) and just create the `user-config.yml` with only the variables you want to override.

### Disable host-only adapter

For example if you want to disable the `host-only` network adapter and only use NAT, then the `user-config.yml` can look like this:

```yaml
vagrant_use_host_only: 0
```

### Proxy settings

You can so that the Vagrant box will use a proxy. Example below show you how to do this in your `user-config.yml`:

```yaml
vagrant_proxy_enabled: true
```

To set proxy use the environment variables which `vagrant-proxyconf` looks at. Read official documentation: [vagrant-proxy](http://tmatilai.github.io/vagrant-proxyconf/)

**IMPORTANT!** In Windows 10 `vagrant-proxyconf` plugin will work with version `1.5.2`, `2.0.1` or later.

### Provision with different Ansible playbook

If you want some else than just a simple Docker CE installation then you can override `ansible_playbook` to point to a different playbook in a sub directory of
this repo, suggest creating directory `ansible-overrides` which is ignored by `.gitignore` and put your playbook there. You can also override the Ansible galaxy
requirements file by setting variable `ansible_requirements`.
