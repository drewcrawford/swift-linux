#!/bin/bash
sed "s/__TAG__/$tag/" build.dockerfile > Dockerfile.tagged
docker build -f Dockerfile.tagged -t swift-tmp .