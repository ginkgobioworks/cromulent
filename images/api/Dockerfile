FROM cromulent/passenger
MAINTAINER Giles Hall <giles@ginkgobioworks.com>
EXPOSE 8000 8100
CMD ["/entrypoint.sh"]

# API Server
RUN apt-get install -qy arvados-api-server runit

RUN mkdir /var/log/sv-nginx/ && \
    mkdir /var/log/sv-puma/ && \
    chown www-data.www-data /var/log/sv-*

COPY etc_arvados_api/* /etc/arvados/api/
COPY etc_service/ /etc/service/
COPY wait-for-it.sh /wait-for-it.sh
COPY api-nginx.conf /etc/nginx/sites-enabled
COPY entrypoint.sh /entrypoint.sh

