#!/bin/bash

init_db() {
    local touchfn=/var/run/api-init
    source /etc/profile.d/rvm.sh
    /wait-for-it.sh -h database -p 5432
    if [[ `psql -tAc "SELECT 1 FROM pg_database WHERE datname='arvados_production'"` != "1" ]]; then
        psql -c "CREATE ROLE arvados ENCRYPTED PASSWORD 'arvados' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;"
        psql -c "CREATE DATABASE arvados_production OWNER arvados ENCODING 'UTF8' TEMPLATE template0;"
    fi
    if [ -e $touchfn ]; then
        return
    fi
    dpkg-reconfigure arvados-api-server
    service nginx stop
}

init_envsh() {
    export | grep -v HOME > /env
    echo "#!/bin/bash" > /env.sh
    echo ". /env" >> /env.sh
    echo "exec /usr/local/rvm/wrappers/default/ruby \"\$@\"" >> /env.sh
    chmod 755 /env.sh
    mkdir /env.puma
    echo "ws-only" > /env.puma/ARVADOS_WEBSOCKETS
    mkdir -p /var/www/arvados-api/current/tmp/cache/
    chown www-data.www-data /var/www/arvados-api/current/tmp/cache/
}


if [[ $# -eq 0 ]]; then
    init_db
    init_envsh
    exec /usr/sbin/runsvdir-start
fi
exec $@
