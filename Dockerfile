FROM ubuntu:18.04

LABEL maintainer="saul.pina@ingeint.com"

ENV DEPLOYER_HOME /idempiere
ENV IS_DOCKER true

WORKDIR $DEPLOYER_HOME

RUN apt-get update && \
    apt-get install -y --no-install-recommends telnet expect && \
    rm -rf /var/lib/apt/lists/*

COPY deployer.sh $DEPLOYER_HOME

RUN ln -s $DEPLOYER_HOME/deployer.sh /usr/bin/deployer

ENTRYPOINT ["./deployer.sh"]
