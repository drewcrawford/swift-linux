#!/bin/bash
docker build -f swift.dockerfile -t $username/swift:$tag .
docker tag $username/swift:$tag $username/swift:latest 