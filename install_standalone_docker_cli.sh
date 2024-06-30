DOCKER_CLI_VERSION=${DOCKER_CLI_VERSION:-27.0.2}
DOCKER_COMPOSE_VERSION=${DOCKER_COMPOSE_VERSION:-2.28.1}

DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins

wget -O docker-cli.tgz -q https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_CLI_VERSION}.tgz \
  && tar -zxf docker-cli.tgz docker/docker \
  && rm docker-cli.tgz \
  && sudo cp docker/docker /usr/local/bin/docker \
  && rm docker/docker && rmdir docker
echo "--> Installed Docker CLI! ($DOCKER_CLI_VERSION)"

DOCKER_COMPOSE_CLI_PLUGIN=$DOCKER_CONFIG/cli-plugins/docker-compose
wget -O $DOCKER_COMPOSE_CLI_PLUGIN -q https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64
chmod +x $DOCKER_COMPOSE_CLI_PLUGIN
echo "--> Installed Docker Compose CLI Plugin! ($DOCKER_COMPOSE_VERSION)"
