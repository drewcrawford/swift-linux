echo "Building runtime image..."
id=$(docker create drewcrawford/swift:latest)
docker cp $id:usr/local/lib/swift - > swiftlibs.tar
docker build -f Runtime.dockerfile -t $username/swift-runtime:latest .
docker tag $username/swift-runtime:latest $username/swift-runtime:$tag