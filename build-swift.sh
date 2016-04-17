#!/bin/bash
if [ "$tag" == "" ]; then
    echo "Please set a tag"
    exit 1
fi
sed "s/__TAG__/$tag/" build.dockerfile > Dockerfile.tagged
docker build -f Dockerfile.tagged -t swift-tmp .