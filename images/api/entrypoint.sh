#!/bin/bash
set -e

. /etc/arvados/common.sh

init_db()
{
    wait_on database 5432 0
    db_name=arvados_$RAILS_ENV
    if db_exists $db_name; then
        return
    fi
    db_pipe << SQLEND
CREATE ROLE arvados ENCRYPTED PASSWORD 'arvados' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;
CREATE DATABASE $db_name OWNER arvados ENCODING 'UTF8' TEMPLATE template0;
SQLEND
}

init_app()
{
    dpkg-reconfigure arvados-api-server
    service nginx stop
}

init_env() 
{
    mkdir /env.puma
    echo "ws-only" > /env.puma/ARVADOS_WEBSOCKETS
    mkdir -p /var/www/arvados-api/current/tmp/cache/
    chown www-data.www-data /var/www/arvados-api/current/tmp/cache/
}


if [[ $# -eq 0 ]]; then
    init
    exec /usr/sbin/runsvdir-start
fi
exec $@
