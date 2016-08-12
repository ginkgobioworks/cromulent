#!/bin/bash

makekey() 
{
    length=$1
    if test -z "$length"; then
        length=32
    fi
    pool=$2
    if test -z "$pool"; then
        pool="A-Za-z0-9"
    fi
    key="cat /dev/urandom | tr -dc '$pool' | head -c $length"
    key=$(sh -c "$key")
    echo $key
}

env_instance() 
{
    local ARVADOS_DOMAIN=${ARVADOS_DOMAIN:-dev.arvados}
    local UUID_PREFIX=${UUID_PREFIX:-$(makekey 5 '0-9a-z')}
    local SSO_APP_SECRET=${SSO_APP_SECRET:-$(makekey)}
    local SECRET_TOKEN=${SECRET_TOKEN-$(makekey)}
    local PGUSER=${PGUSER-root}
    local PGPASSWORD=${PGPASSWORD:-$(makekey)}
    local PGHOST=${PGHOST:-database}
    local RAILS_ENV=${RAILS_ENV:-production}
    local VM_UUID_PREFIX=${VM_UUID_PREFIX:-$(makekey 16)}-$UUID_PREFIX
    local BLOB_SIGNING_KEY=${BLOB_SIGNING_KEY:-$(makekey)}
    local SSO_APP_SECRET=${SSO_APP_SECRET:-$(makekey)}
    local SSO_APP_ID=${SSO_API_ID:-$(makekey)}
    local SSO_DEFAULT_LINK_URL=${SSO_DEFAULT_LINK_URL:-https://sso.$ARVADOS_DOMAIN}
    local ARVADOS_LOGIN_BASE=${ARVADOS_LOGIN_BASE:-https://${UUID_PREFIX}.${ARVADOS_DOMAIN}/login}
    local ARVADOS_V1_BASE=${ARVADOS_V1_BASE:-https://${UUID_PREFIX}.${ARVADOS_DOMAIN}/arvados/v1}
    local SSO_PROVIDER_URL=${SSO_PROVIDER_URL:-https://sso.${ARVADOS_DOMAIN}}
    local WORKBENCH_ADDRESS=${WORKBENCH_ADDRESS:-https://workbench.${ARVADOS_DOMAIN}}
    local WEBSOCKET_ADDRESS=${WEBSOCKET_ADDRESS:=-wss://api:8100/websocket}

cat << VARS 
ARVADOS_DOMAIN=$ARVADOS_DOMAIN
UUID_PREFIX=$UUID_PREFIX
SSO_APP_SECRET=$SSO_APP_SECRET
SECRET_TOKEN=$SECRET_TOKEN
POSTGRES_USER=$PGUSER
POSTGRES_PASSWORD=$PGPASSWORD
RAILS_ENV=$RAILS_ENV
VM_UUID_PREFIX=$VM_UUID_PREFIX
BLOB_SIGNING_KEY=$BLOB_SIGNING_KEY
SSO_APP_SECRET=$SSO_APP_SECRET
SSO_APP_ID=$SSO_APP_ID
SSO_DEFAULT_LINK_URL=$SSO_DEFAULT_LINK_URL
SSO_PROVIDER_URL=$SSO_PROVIDER_URL
ARVADOS_LOGIN_BASE=$ARVADOS_LOGIN_BASE
ARVADOS_V1_BASE=$ARVADOS_V1_BASE
WORKBENCH_ADDRESS=$WORKBENCH_ADDRESS
WEBSOCKET_ADDRESS=$WEBSOCKET_ADDRESS
VARS
}

ARVADOS_DOMAIN=${ARVADOS_DOMAIN:-dev.arvados}
if test ! -z "$1"; then
    ARVADOS_DOMAIN=$1
fi

env_instance
