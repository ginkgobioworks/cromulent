#!/usr/bin/env bash

NGINX_CERT_DIR={$NGINX_CERT_DIR:-/certs}

envsub()
{
    tmpl=$1
    target_dir=$2
    mask=$3
    target=$target_dir/$(basename $tmpl .tmpl)
    if test "$(basename $target)" == "$(basename $tmpl)"; then
        echo interpolate failed beause $tmpl doesn\'t end with ".tmpl"
        return
    fi
    echo envsubst "$mask" IN $tmpl OUT $target
    envsubst "$mask" < $tmpl > $target
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
    outdir=$1
    fqdn=$2
    openssl req \
        -nodes -new -x509 \
        -keyout $outdir/${fqdn}.key \
        -out $outdir/${fqdn}.crt \
        -subj "/C=XX/ST=XX/L=Earth/O=Earth/OU=Earth/CN=${fqdn}/emailAddress=humans@earth.com"
}

make_certs()
{
    if test ! -d /certs; then
        mkdir /certs
        make_cert /certs ${UUID_PREFIX}.${ARVADOS_DOMAIN}
        make_cert /certs ws.${UUID_PREFIX}.${ARVADOS_DOMAIN}
        make_cert /certs sso.${ARVADOS_DOMAIN}
        make_cert /certs workbench.${ARVADOS_DOMAIN}
    fi
}

init_nginx_conf()
{
    for tmplfn in /etc/nginx/tmpl.d/*.tmpl; do
        envsub $tmplfn /etc/nginx/conf.d '${ARVADOS_DOMAIN} ${UUID_PREFIX}'
    done
}

if [[ $# -eq 0 ]]; then
    init_nginx_conf
    make_certs
    dns_hostname_wait sso
    dns_hostname_wait api
    dns_hostname_wait workbench

    exec nginx -g "daemon off;"
fi
exec "$@"
