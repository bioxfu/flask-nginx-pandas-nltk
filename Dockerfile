# Version: 0.0.1
FROM ubuntu

MAINTAINER Xing Fu "bio.xfu@gmail.com"

RUN perl -p -i.orig -e 's/archive.ubuntu.com/mirrors.aliyun.com\/ubuntu/' /etc/apt/sources.list; \
    apt-get update; \
    apt-get install -y build-essential git python python-dev python-setuptools nginx uwsgi uwsgi-plugin-python supervisor; \
    apt-get clean; \
    apt-get autoremove; \
    easy_install pip

RUN echo "daemon off;" >> /etc/nginx/nginx.conf; \
    mkdir -p /var/log/uwsgi

ADD supervisor.conf /etc/supervisor/conf.d/

ADD nginx.conf /etc/nginx/conf.d/

ADD requirements.txt /src/

RUN pip install -r /src/requirements.txt

EXPOSE 5000

ADD uwsgi.ini /var/www/

WORKDIR /var/www/

CMD ["supervisord", "-n"]

