FROM cromulent/passenger
MAINTAINER Giles Hall <giles@ginkgobioworks.com>
RUN apt-get install -qy graphviz git python-arvados-python-client arvados-workbench
RUN service nginx status|grep running && service nginx stop
COPY etc_arvados_workbench/* /etc/arvados/workbench/
COPY wait-for-it.sh /wait-for-it.sh
COPY workbench-nginx.conf /etc/nginx/sites-enabled
COPY nginx-local.conf /etc/nginx/nginx-local.conf
COPY entrypoint.sh /entrypoint.sh
EXPOSE 9000
CMD ["/entrypoint.sh"]
