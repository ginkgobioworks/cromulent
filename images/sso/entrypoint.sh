#!/usr/bin/env bash
set -e

init_db() {
    local touchfn=/var/run/sso-init
    source /etc/profile.d/rvm.sh
    /wait-for-it.sh -h database -p 5432
    if [[ `psql -tAc "SELECT 1 FROM pg_database WHERE datname='arvados_sso_production'"` != "1" ]]; then
        psql -c "CREATE ROLE arvados_sso ENCRYPTED PASSWORD 'arvados_sso' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;"
        psql -c "CREATE DATABASE arvados_sso_production OWNER arvados_sso ENCODING 'UTF8' TEMPLATE template0;"
    fi
    if [ -e $touchfn ]; then
        return
    fi
    dpkg-reconfigure arvados-sso-server
    service nginx stop
    cd /var/www/arvados-sso/current
    sudo -E -u www-data HOME=/tmp RAILS_ENV=production /usr/local/rvm/bin/rvm-exec default bundle exec rails console << INPUT
c = Client.new
c.name = "joshid"
c.app_id = "arvados-server"
c.app_secret = "$SECRET_TOKEN"
c.save!
quit
INPUT
}

init_envsh() {
    echo "#!/bin/bash" > /env.sh
    export | grep -v HOME >> /env.sh
    echo "exec /usr/local/rvm/wrappers/default/ruby \"\$@\"" >> /env.sh
    chmod 755 /env.sh
}

if [[ $# -eq 0 ]]; then
    init_db
    init_envsh
    exec nginx -g "daemon off;"
fi
exec $@
