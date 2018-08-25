# vagrant-wsl-docker

This repository will guide you how to setup `docker` command to be used directly from `bash` using Windows Subsystem for Linux (WSL).

## Prerequisites

* VirtualBox installed in Windows
* Vagrant installed in Windows
* Plugin `vbguest` installed in vagrant: `vagrant plugin install vagrant-vbguest`

## How to set it up

Install `docker` client by running the following inside `bash`:

```console
wget -q https://download.docker.com/linux/static/stable/x86_64/docker-18.03.1-ce.tgz \
  && tar -zxf docker-18.03.1-ce.tgz docker/docker \
  && rm docker-18.03.1-ce.tgz \
  && sudo cp docker/docker /usr/local/bin/docker \
  && rm docker/docker && rmdir docker
```

Next is to append configuration to `~/.bashrc` for `docker` to use TCP instead of file:

```console
echo 'export DOCKER_HOST=tcp://127.0.0.1:2375' >> ~/.bashrc
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

```console
vagrant up
```

After this point the VM is ready and the Docker daemon is started. Test the `docker` client by running the following command:

```console
docker info
```

## General usage tip

After the you have setup everything and run the `vagrant up` once then from that point you can start and stop the box by
explicitly specifying the ID. This ID can be found using the command `vagrant global-state`. Using the ID will allow you
to start, stop and reprovision the box from any location (you do not need to go to the directory of the Vagrantfile).

## Advanced

If you would like to override the Ansible playbook executed to install and configure Docker then this is possible by setting
an environment variable called `PLAYBOOK_OVERRIDE` (default: `ansible/setup-docker.yml`). Also there is a possibility to install
additional roles that is required by the playbook run and this can be achieved by setting another environment variable called
`REQUIREMENTS_OVERRIDE` (default: `ansible/requirements.yml`).