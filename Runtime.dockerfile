FROM debian:latest
MAINTAINER Drew Crawford

RUN \
apt-get update && \
apt-get install -y --no-install-recommends libicu52 libbsd0 && \
# clean up \
cd / && \
rm -rf /tmp/swift.tar.gz /swift-dev && \
apt-get remove --purge -y $BUILDTIME_PACKAGES && \
apt-get autoremove --purge -y && \
apt-get clean -y && \
apt-get autoclean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD swiftlibs.tar /usr/local/lib/