#!/bin/bash
sed "s/__TAG__/master/" build.dockerfile > Dockerfile.tagged
sed -i "" "s+RUN ./utils/build-script+# RUN ./utils/build-script+" Dockerfile.tagged 
docker build -f Dockerfile.tagged -t swift-tmp .