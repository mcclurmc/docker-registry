# VERSION 0.1
# DOCKER-VERSION  0.7.3
# AUTHOR:         Sam Alba <sam@docker.com>
# DESCRIPTION:    Image with docker-registry project and dependecies
# TO_BUILD:       docker build -rm -t registry .
# TO_RUN:         docker run -p 5000:5000 registry

FROM trusty-ruby-base:latest

EXPOSE 80
EXPOSE 443

EXPOSE 5000

RUN apt-get update; \
    apt-get upgrade -y; \
    apt-get install -y build-essential python-dev libevent-dev \
                       python-pip libssl-dev liblzma-dev libffi-dev \
                       nginx-full

ADD . /docker-registry
WORKDIR /docker-registry
RUN pip install .

ADD ./config/boto.cfg		 /etc/boto.cfg
ADD ./contrib/nginx_1-3-9.conf	 /etc/nginx/conf.d/docker-registry.conf
ADD ./config/supervisord.conf	 /etc/supervisor/conf.d/registry.conf

ENV PORT_WWW 5000

CMD ["/usr/local/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
