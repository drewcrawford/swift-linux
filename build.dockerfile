FROM debian:latest
MAINTAINER Drew Crawford

ENV SWIFT_TAG="__TAG__" RUNTIME_PACKAGES="clang libedit2 libpython2.7 libxml2 libicu52" BUILDTIME_PACKAGES="git ca-certificates python ninja-build cmake uuid-dev libbsd-dev libicu-dev pkg-config libedit-dev file libxml2-dev python-dev libncurses5-dev libsqlite3-dev libreadline6-dev rsync"

# for libdispatch, we also need more stuff
ENV BUILDTIME_PACKAGES="$BUILDTIME_PACKAGES make gobjc automake autoconf libtool pkg-config systemtap-sdt-dev libblocksruntime-dev libkqueue-dev libpthread-workqueue-dev libbsd-dev"

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

#libdispatch needs submodules tho, LOL
RUN cd ../swift-corelibs-libdispatch && git submodule init && git submodule update

# The silly update-checkout script does not understand matching the swift checkout ref 
# In practice what you're supposed to do (I think!  It's not documented!) is check out the same snapshot tag  
# Not all the folders have them (where do some of them come from??) but we'll just try them all 
# see http://stackoverflow.com/a/8213585/116834 
ADD update-tags.sh /swift-dev/update-tags.sh
RUN bash /swift-dev/update-tags.sh

# Apply patches here 
# ADD SAMPLE.patch /swift-dev/
# RUN cd ../swift-corelibs-libdispatch && git apply < ../SAMPLE.patch
# or for AM
# RUN git config --global user.email "drew@sealedabstract.com" && git config --global user.name "Drew Crawford"
# RUN git am -3 < ../SAMPLE.patch

# use hubertus's newest libdispatch
RUN cd ../swift-corelibs-libdispatch/libpwq && git checkout origin/master

# apply PR 62
RUN git config --global user.email "drew@sealedabstract.com" && git config --global user.name "Drew Crawford"
RUN cd ../swift-corelibs-libdispatch && git fetch origin pull/62/head:PR62 && git merge PR62

# apply ⛏ 1242
ADD 0001-Don-t-run-libdispatch-tests.patch /swift-dev/
RUN git am -3 ../0001-Don-t-run-libdispatch-tests.patch

# And now we build, like a good little linuxen. 
# I believe this is what the linux build script does.  In practice, this builds a system into /tmp/install and then tars it up. 
ADD presets.ini /swift-dev/swift/presets.ini
RUN ./utils/build-script --preset=drew --preset-file=presets.ini --preset-file=utils/build-presets.ini installable_package="/tmp/swift.tar.gz" install_destdir="/tmp/install/"

