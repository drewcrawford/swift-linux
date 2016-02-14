#!/bin/bash
id=$(docker create swift-tmp)
docker cp $id:/tmp/swift.tar.gz .
rm -rf fakeroot
mkdir -p fakeroot/usr/local
tar xf swift.tar.gz -C fakeroot/usr/local --strip-components 1
rm -rf swift.tar.gz
#patch silly dispatch
mkdir fakeroot/usr/local/include/dispatch/haxx 
mv fakeroot/usr/local/include/dispatch/Dispatch.swift* fakeroot/usr/local/include/dispatch/haxx/
mv fakeroot/usr/local/include/dispatch/module.map fakeroot/usr/local/include/dispatch/haxx/

#we need to file a ⛏ about this silly workaround at some point
#but we have to wait for ⛏729 to get resolved first
#since the repro steps will change
sed -i '' "s+/tmp/install///usr/include/dispatch/dispatch.h+/usr/local/include/dispatch/dispatch.h+" fakeroot/usr/local/include/dispatch/haxx/module.map
tar czf swift-local.tar.gz -C fakeroot .
rm -rf fakeroot