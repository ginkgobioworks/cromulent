#!/usr/bin/env bash
set -e

. /etc/arvados/common.sh

init_app() {
    dpkg-reconfigure arvados-workbench
    service nginx stop
}

if [[ $# -eq 0 ]]; then
    init
    wait_on api 8100 0
    wait_on api 8000 0
    exec nginx -g "daemon off;"
fi

exec $@
