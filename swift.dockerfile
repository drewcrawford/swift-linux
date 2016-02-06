FROM debian:latest
MAINTAINER Drew Crawford
RUN apt-get update && apt-get install --no-install-recommends -y clang libedit2 libpython2.7 libxml2 libicu52 && rm -rf rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD swift-local.tar.gz /