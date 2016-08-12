#!/usr/bin/env bash

NGINX_CERT_DIR={$NGINX_CERT_DIR:-/certs}

envsub()
{
    tmpl=$1
    target_dir=$2
    target=$target_dir/$(basename $tmpl .tmpl)
    if test "$(basename $target)" == "$(basename $tmpl)"; then
        echo interpolate failed beause $tmpl doesn\'t end with ".tmpl"
        return
    fi
    envsubst $tmpl > $target
}

dns_hostname_wait()
{
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

make_cert()
{
    fqdn=$1
    openssl req \
        -nodes -new -x509 \
        -keyout ${fqdn}.key \
        -out ${fqdn}.crt \
        -subj "/C=Earth/S=Earth/L=Earth/O=Earth/OU=Earth/CN=${fqdn}/emailAddress=humans@earth.com"
}

make_certs()
{
    if test ! -d /certs; then
        mkdir /certs
        make_cert ${UUID_PREFIX}.${ARVADOS_DOMAIN}
        make_cert ws.${UUID_PREFIX}.${ARVADOS_DOMAIN}
        make_cert sso.${ARVADOS_DOMAIN}
        make_cert workbench.${ARVADOS_DOMAIN}
    fi
}

init_nginx_conf()
{
    for tmplfn in /etc/conf.d/*.tmpl; do
        envsub $tmplfn /etc/nginx/conf.d
    done
}

if [[ $# -eq 0 ]]; then
    dns_hostname_wait sso
    dns_hostname_wait api
    dns_hostname_wait workbench

    exec nginx -g "daemon off;"
fi
exec "$@"
