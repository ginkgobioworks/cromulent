#!/usr/bin/env bash

wait_on() {
    hostname=$1
    echo "waiting for $hostname to have a resolvable name"
    while true; do
        if [ ! -z "$(getent hosts $hostname)" ]; then
            break
        fi
        sleep 1;
    done
    echo "$hostname resolves!"
}

envsub()
{
    tmpl=$1
    target_dir=$2
    target=$target/$(basename $tmpl .tmpl)
    if [ $(basename $target) == $(basename $tmpl) ]; then
        echo interpolate failed beause $tmpl doesn\'t end with ".tmpl"
        return
    fi
    envsubst $tmpl > $target
}

make_cert()
{
    fqdn=$1
    openssl req \
        -nodes -new -x509 \
        -keyout ${fqdn}.key \
        -out ${fqdn}.crt \
        -subj "/C=Earth/S=Earth/L=Earth/O=Earth/OU=Earth/CN=${fqdn}/emailAddress=humans@earth.com"
}

for tmplfn in /etc/conf.d/*.tmpl; do
    envsub $tmplfn /etc/nginx/conf.d
done

if test ! -d /certs; then
    make_cert ${UUID_PREFIX}.${ARVADOS_DOMAIN}
    make_cert ws.${UUID_PREFIX}.${ARVADOS_DOMAIN}
    make_cert sso.${ARVADOS_DOMAIN}
    make_cert workbench.${ARVADOS_DOMAIN}
fi

cd -
if [[ $# -eq 0 ]]; then
    wait_on sso
    wait_on api
    wait_on workbench
    exec nginx -g "daemon off;"
fi
exec "$@"
