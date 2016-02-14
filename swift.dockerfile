FROM debian:latest
MAINTAINER Drew Crawford
#these: libblocksruntime-dev libkqueue0 libpthread-workqueue0 are libdispatch-related
RUN apt-get update && apt-get install --no-install-recommends -y clang libedit2 libpython2.7 libxml2 libicu52 libblocksruntime-dev libkqueue0 libpthread-workqueue0 && rm -rf rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD swift-local.tar.gz /