wait_on () 
{
    host=$1
    port=$2
    timeout=$3
    if test -z $timeout; then
        $timeout=60
    fi
    wait-for-it -t $timeout $host:$port
}

db_pipe()
{
    args=$1
    PGUSER=$POSTGRES_USER \
    PGPASSWORD=$POSTGRES_PASSWORD \
    PGHOST=database \
    psql $args
}

db_exists()
{
    export db_name=$1
    query="SELECT 1 FROM pg_database WHERE datname='$db_name'"
    if test "$(echo $query | db_pipe -tA)" = "1"; then
        return 0
    fi
    return 1
}


init_db() { 
    return 
}

init_app() { 
    return 
}

init_env() { 
    return 
}

init_ruby_wrapper() 
{
    export | grep -v HOME  | grep -v rvm >> /env
    echo "#!/bin/bash" > /ruby_wrapper.sh
    cat /env >> /ruby_wrapper.sh
    echo "exec /usr/local/rvm/wrappers/default/ruby \"\$@\"" >> /ruby_wrapper.sh
    chmod 755 /ruby_wrapper.sh
}

init() 
{
    source /etc/profile.d/rvm.sh
    init_ruby_wrapper
    init_db
    init_env
    guard=/var/run/arvados-app.init
    if test ! -e $guard; then
        init_app
        touch $guard
    fi
}
