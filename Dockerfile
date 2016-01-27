FROM debian:latest
MAINTAINER Drew Crawford

ENV SWIFT_TAG="__TAG__" RUNTIME_PACKAGES="clang libedit2 libpython2.7 libxml2 libicu52" BUILDTIME_PACKAGES="git ca-certificates python ninja-build cmake uuid-dev libbsd-dev libicu-dev pkg-config libedit-dev file libxml2-dev python-dev libncurses5-dev libsqlite3-dev libreadline6-dev rsync"

#apply patches here
# ADD SR-437.patch /

# Create a directory to work in 
RUN mkdir swift-dev
WORKDIR /swift-dev
# Install the runtime and build-time dependencies 
RUN apt-get update
RUN apt-get install $RUNTIME_PACKAGES $BUILDTIME_PACKAGES -y --no-install-recommends

RUN git clone https://github.com/apple/swift.git
WORKDIR /swift-dev/swift
# submodules?  Where we're going, we don't need submodules! 
RUN ./utils/update-checkout --clone

# The silly update-checkout script does not understand matching the swift checkout ref 
# In practice what you're supposed to do (I think!  It's not documented!) is check out the same snapshot tag  
# Not all the folders have them (where do some of them come from??) but we'll just try them all 
# see http://stackoverflow.com/a/8213585/116834 
ADD update-tags.sh /swift-dev/update-tags.sh
RUN bash /swift-dev/update-tags.sh

# Apply patches here 
# cd ../swift-corelibs-foundation
# git apply < /SR-437.patch
# cat Foundation/NSPathUtilities.swift

# And now we build, like a good little linuxen. 
# I believe this is what the linux build script does.  In practice, this builds a system into /tmp/install and then tars it up. 
RUN ./utils/build-script --preset=buildbot_linux install_destdir="/tmp/install" installable_package="/tmp/swift.tar.gz"

# Install our tarball to /usr/local 
RUN tar xf /tmp/swift.tar.gz -C /usr/local --strip-components 1

# Clean up 
WORKDIR /
RUN rm -rf /tmp/swift.tar.gz /swift-dev
RUN apt-get remove --purge -y $BUILDTIME_PACKAGES
RUN apt-get autoremove --purge -y
RUN apt-get clean -y
RUN apt-get autoclean -y
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["bash"]

