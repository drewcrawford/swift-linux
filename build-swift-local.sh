#!/bin/bash
set -e
id=$(docker create swift-tmp)
docker cp $id:/tmp/swift.tar.gz .
rm -rf fakeroot
mkdir -p fakeroot/usr/local
tar xf swift.tar.gz -C fakeroot/usr/local --strip-components 1
tar czf swift-local.tar.gz -C fakeroot .
rm -rf fakeroot
rm -rf swift.tar.gz