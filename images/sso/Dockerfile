FROM cromulent/passenger
MAINTAINER Giles Hall <giles@ginkgobioworks.com>
RUN apt-get install -qy arvados-sso-server postgresql-client
COPY etc_arvados_sso/* /etc/arvados/sso/
COPY wait-for-it.sh /wait-for-it.sh
COPY sso-nginx.conf /etc/nginx/sites-enabled
COPY entrypoint.sh /entrypoint.sh
EXPOSE 8900
CMD ["/entrypoint.sh"]
