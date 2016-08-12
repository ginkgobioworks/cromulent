FROM cromulent/base
MAINTAINER Giles Hall <giles@ginkgobioworks.com>

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 && \
    apt-get install -y apt-transport-https ca-certificates && \
    echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list && \
    sudo apt-get update && \
    sudo apt-get install -y nginx-extras passenger

# for passenger
RUN mkdir -p /var/www && chown -R www-data.www-data /var/www
RUN echo "include /etc/nginx/nginx-local.conf;" >> /etc/nginx/nginx.conf && \
    touch /etc/nginx/nginx-local.conf
