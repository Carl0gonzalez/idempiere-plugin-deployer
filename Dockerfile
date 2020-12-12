FROM ubuntu:18.04

LABEL maintainer="orlando.curieles@ingeint.com"

ENV IS_DOCKER true

RUN apt-get update && \
    apt-get install -y --no-install-recommends telnet expect && \
    rm -rf /var/lib/apt/lists/*

COPY deployer.sh /
COPY docker-entrypoint.sh /

RUN ln -s /deployer.sh /usr/bin/deployer

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["deployer"]
