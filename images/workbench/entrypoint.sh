#!/usr/bin/env bash
set -e

init_workbench() {
    local touchfn=/var/run/work-bench-init
    /wait-for-it.sh -t 0 -h api -p 8100
    /wait-for-it.sh -t 0 -h api -p 8000
    if [ -e $touchfn ]; then
        return
    fi
    source /etc/profile.d/rvm.sh
    dpkg-reconfigure arvados-workbench
    service nginx stop
    touch $touchfn
}

init_envsh() {
    echo "#!/bin/bash" > /env.sh
    export | grep -v HOME >> /env.sh
    echo "exec /usr/local/rvm/wrappers/default/ruby \"\$@\"" >> /env.sh
    chmod 755 /env.sh
}

if [[ $# -eq 0 ]]; then
    init_envsh
    init_workbench
    exec nginx -g "daemon off;"
fi

exec $@
