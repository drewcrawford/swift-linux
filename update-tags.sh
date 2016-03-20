#!/bin/bash
set -e
if [ "$SWIFT_TAG" == "master" ]; then
    echo "Not updating tags; you're building master."
    exit 0
fi

#projects that have no tag
NOTAG=("swift-dev" "swift-corelibs-libdispatch" "compiler-rt")
#compiler-rt does not have a tag during swift-DEVELOPMENT-SNAPSHOT-2016-03-16-a but should be present in the next release
for file in `find ../ -maxdepth 1 -type d`; do 
    skip=0
    for n in "${NOTAG[@]}"; do 
        echo "test ../$n $file"
        if [[ "../$n" = "$file" ]]; then 
            skip=1
            break;
        fi
        if [[ "../" = "$file" ]]; then
            skip=1
            break;
        fi
    done
    if [[ $skip = 0 ]]; then 
        cd $file 
        echo checking out in `pwd`
        git checkout $SWIFT_TAG
    fi 
done