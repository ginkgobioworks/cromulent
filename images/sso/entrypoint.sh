#!/usr/bin/env bash
set -e

. /etc/arvados/common.sh

init_db()
{
    wait_on database 5432 0
    db_name=arvados_sso_$RAILS_ENV
    if db_exists $db_name; then
        return
    fi
    db_pipe << SQLEND
CREATE ROLE arvados_sso ENCRYPTED PASSWORD 'arvados_sso' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;
CREATE DATABASE $db_name OWNER arvados_sso ENCODING 'UTF8' TEMPLATE template0;
SQLEND
}

init_app()
{
    dpkg-reconfigure arvados-sso-server
    service nginx stop
    cd /var/www/arvados-sso/current
    sudo -E -u www-data HOME=/tmp RAILS_ENV=production /usr/local/rvm/bin/rvm-exec default bundle exec rails console << CODE
c = Client.new
c.name = "joshid"
c.app_id = "arvados-server"
c.app_secret = "$SECRET_TOKEN"
c.save!
quit
CODE
}

if [[ $# -eq 0 ]]; then
    init
    exec nginx -g "daemon off;"
fi
exec $@
