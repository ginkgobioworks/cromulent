FROM nginx
MAINTAINER Giles Hall <giles@ginkgobioworks.com>
ENTRYPOINT ["/entrypoint.sh"]
COPY wait-for-it.sh /usr/bin/wait-for-it
COPY nginx-sites.conf.tmpl /etc/nginx/tmpl.d/
COPY entrypoint.sh /entrypoint.sh
