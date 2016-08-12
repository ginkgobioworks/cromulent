FROM nginx
MAINTAINER Giles Hall <giles@ginkgobioworks.com>
COPY wait-for-it.sh /wait-for-it.sh
COPY entrypoint.sh /entrypoint.sh
COPY nginx-sites.conf.tmpl /etc/nginx/tmpl.d/
ENTRYPOINT ["/entrypoint.sh"]
