FROM debian:jessie-slim

MAINTAINER Robert Schumann <gutmensch@n-os.org>

ENV raumserver_release "http://bassmaniacs.com/data/appBinaries/raumserver/currentVersion"
ENV raumserver_http "8090"
ENV PATH /opt:$PATH

WORKDIR /opt

COPY start.sh ./start.sh
COPY settings.xml ./settings.xml

RUN set -x \
      && apt-get update \
      && apt-get install -y --no-install-recommends wget unzip binutils libunwind8 \
      && rm -rf /var/lib/apt/lists/*

RUN set -x \
      && wget -q --no-check-certificate $raumserver_release/raumserverDaemon_linux_ARMV7HF.zip \
      && unzip raumserverDaemon_linux_ARMV7HF.zip -d raumserver && rm -f raumserverDaemon_linux_ARMV7HF.zip \
      && mv raumserver/settings.xml raumserver/settings.xml.dist \
      && sed -i "s%RAUMSERVER_HTTP%"$raumserver_http"%" settings.xml \
      && mv settings.xml raumserver/ \
      && strip -v raumserver/raumsrvDaemon \
      && apt-get autoremove -y wget unzip binutils \
      && chmod +x start.sh

EXPOSE $raumserver_http

CMD ["start.sh"]
