# cromulent

A nascent experiment utilizing docker-compose to build Arvados.

## requirements

- [Docker 1.11](https://docs.docker.com/engine/installation/)
- [docker-compose](https://docs.docker.com/compose/install/)

## getting started

This deployment framework is configured around a chain of environment
variables, and all of these variables are sourced from a single file that
contains the complete set.  Use the script "env.sh" to build a new boiler plate
environment.

```bash
./env.sh dev.arvados > dev.arvados.env
```

In order to tie `docker-compose` to your config, you need to export one
variable, `ARVADOS_DOMAIN` to your running environment:

```bash
export ARVADOS_DOMAIN=arvados.dev
```

Now that you've made your boilerplate, you can proceed to build your images.
You will only need to do this once; changing a configuration variable derived
from the environment does not require that you re-run the build, only restart
the affected containers.

```bash
alias dcb="docker-compose build"
dcb base; dcb passenger; dcb
```

If you are doing this from scratch, this will take 10-20mins.  While the build
is churning away, open up your generated environment file in your editor and
adjust as needed.  Everything is setup to be ephemeral, but you could easily
store these environment files in version control.  Here is an example
configuration:

```bash
./env.sh arvados.my.domain
ARVADOS_DOMAIN=arvados.my.domain
UUID_PREFIX=o38vl
SSO_APP_SECRET=5NBObGf2SVWFVjSe598gvC8FeBOEBq66
SECRET_TOKEN=HdFt2wXK1Xs2Of40xecDbXbZa3FO3XvO
POSTGRES_USER=root
POSTGRES_PASSWORD=dwbIVJf7sion7JUw6WkancyFF5yOSIoq
RAILS_ENV=production
VM_UUID_PREFIX=mBRu8WvhNzC4dhdE-o38vl
BLOB_SIGNING_KEY=J2Q4MgqFykkJBkaDOcFpy7ApqJF71GPt
SSO_APP_SECRET=5NBObGf2SVWFVjSe598gvC8FeBOEBq66
SSO_APP_ID=bLPfQj9HeIlQWODiRa8G1WhLeEJfiuH8
SSO_DEFAULT_LINK_URL=https://sso.arvados.my.domain
SSO_PROVIDER_URL=https://sso.arvados.my.domain
ARVADOS_LOGIN_BASE=https://o38vl.arvados.my.domain/login
ARVADOS_V1_BASE=https://o38vl.arvados.my.domain/arvados/v1
WORKBENCH_ADDRESS=https://workbench.arvados.my.domain
WEBSOCKET_ADDRESS=-wss://api:8100/websocket
```

## docker-compose cheat sheet

```bash
alias dc="docker-compose"
alias dcb="docker-compose build"
alias dcrm="docker-compose rm"
alias dcu="docker-compose up"
alias dcd="docker-compose down"
alias dcr="docker-compose run"
alias dce="docker-compose exec"
alias dcd="docker-compose stop"

dcu                 # start/restart all containers
dcd                 # stop all running containers
dcs [name]          # stop some/all running containers
dcrm [-f] [name]    # remove the stopped containers
dcb [name]          # build the images
dce <name> [cmd]    # run an interactive command within a new container
dcr <name> [cmd]    # spawn a new interactive command within a running container
```

## the future

The design goal for this work is to build a factory that can create fully
functional Arvados deployments with infrastructure range: from a single host to
a managed cluster.  By breaking down the individual services into their own
docker images and leveraging runtime variables, it should be possible to deploy
a test, development, and production system entirely with `docker-compose`.

## rough roadmap

- Working:
    - proxy
    - base
    - passenger
    - database

- WIP:
    - api
    - sso
    - workbench

- TODO:
    - arv-web
    - bcbio-nextgen
    - compute
    - doc
    - java-bwa-samtools
    - jobs
    - keep
    - keepproxy
    - postgresql
    - shell
    - slurm
    - others?
