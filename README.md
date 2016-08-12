# cromulent

A nascent experiment utilizing docker-compose to build Arvados.

## requirements

- [Docker 1.11](https://docs.docker.com/engine/installation/)
- [docker-compose](https://docs.docker.com/compose/install/)

## getting started

This entire deployment is configured around a chain of environment variables.
All of these variables are sourced from a single file that contains the
entire set.  Use the script "env.sh" to build a new boiler
plate environment.

```bash
./env.sh dev.arvados > dev.arvados.env
```

You also need to export one variable, `ARVADOS_DOMAIN` to your domain:

```bash
export ARVADOS_DOMAIN=arvados.dev
```

Now that you've made your boilerplate, you can now proceed to build your
images.  You will only need to do this once; changing a configuration variable
derived from the environment does not require that you re-run the build, only
restart the affected containers.

```bash
alias dcb="docker-compose build"
dcb base; dcb passenger; dcb
```

If you are doing this from scratch, this will take 10-20mins.  While the build
is churning away, open up your generated envionment file in your editor and
adjust as needed.  Everything is setup to be ephermal, but you could easily
store these config stubs in version control.

Here is a cheatsheet with a few aliases to make it easier to type:

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

The intention with this method is to create a deployment set that can operate
in a range of contexts: from a single host to a managed cluster of docker
servers.  By breaking down the individual services, it should be possible to
deploy a production system entirely with docker.

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
