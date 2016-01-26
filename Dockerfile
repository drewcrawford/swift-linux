FROM debian:latest
MAINTAINER Drew Crawford

ENV SWIFT_TAG="__TAG__" RUNTIME_PACKAGES="clang libedit2 libpython2.7 libxml2 libicu52" BUILDTIME_PACKAGES="git ca-certificates python ninja-build cmake uuid-dev libbsd-dev libicu-dev pkg-config libedit-dev file libxml2-dev python-dev libncurses5-dev libsqlite3-dev libreadline6-dev rsync"

#apply patches here
# ADD SR-437.patch /

RUN \
# Create a directory to work in \
mkdir swift-dev && \
cd swift-dev && \
# Install the runtime and build-time dependencies \
apt-get update && \
apt-get install $RUNTIME_PACKAGES $BUILDTIME_PACKAGES -y --no-install-recommends && \
\
git clone https://github.com/apple/swift.git && \
cd swift && \
# submodules?  Where we're going, we don't need submodules! \
./utils/update-checkout --clone && \
\
# The silly update-checkout script does not understand matching the swift checkout ref \
# In practice what you're supposed to do (I think!  It's not documented!) is check out the same snapshot tag  \
# Not all the folders have them (where do some of them come from??) but we'll just try them all \
find ../ -maxdepth 1 -type d  -exec bash -c '(cd {} && echo checking out in `pwd` && git checkout $SWIFT_TAG)' \; && \
\
# Apply patches here \
# cd ../swift-corelibs-foundation && \
# git apply < /SR-437.patch && \
# cat Foundation/NSPathUtilities.swift && \
# \
cd ../swift && \
\
# And now we build, like a good little linuxen. \
# I believe this is what the linux build script does.  In practice, this builds a system into /tmp/install and then tars it up. \
./utils/build-script --preset=buildbot_linux install_destdir="/tmp/install" installable_package="/tmp/swift.tar.gz" && \
\
# Install our tarball to /usr/local \
tar xf /tmp/swift.tar.gz -C /usr/local --strip-components 1 && \
\
# Clean up \
cd / && \
rm -rf /tmp/swift.tar.gz /swift-dev && \
apt-get remove --purge -y $BUILDTIME_PACKAGES && \
apt-get autoremove --purge -y && \
apt-get clean -y && \
apt-get autoclean -y && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["bash"]

