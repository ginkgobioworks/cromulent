FROM cromulent/passenger
MAINTAINER Giles Hall <giles@ginkgobioworks.com>
RUN apt-get install -qy arvados-api-server runit

# Puma service
ENV WEBSOCKETS_ENV "/websockets"
RUN mkdir -p $WEBSOCKETS_ENV && \
    echo "ws-only" > "$WEBSOCKETS_ENV/ARVADOS_WEBSOCKETS"

COPY etc_arvados_api/* /etc/arvados/api/
COPY etc_service/ /etc/service/
COPY wait-for-it.sh /wait-for-it.sh
COPY api-nginx.conf /etc/nginx/sites-enabled
COPY entrypoint.sh /entrypoint.sh
RUN mkdir /var/log/sv-nginx/ && \
    mkdir /var/log/sv-puma/ && \
    chown www-data.www-data /var/log/sv-*

EXPOSE 8000 8100
CMD ["/entrypoint.sh"]
