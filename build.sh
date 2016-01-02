set -e
username="drewcrawford"
echo "Type tag name"
read tag
sed "s/__TAG__/$tag/" Dockerfile > Dockerfile.tagged
docker build -f Dockerfile.tagged -t $username/swift:latest .
docker tag $username/swift:latest $username/swift:$tag
id=$(docker create drewcrawford/swift:latest)
docker cp $id:usr/local/lib/swift - > swiftlibs.tar
docker build -f Runtime.dockerfile -t $username/swift-runtime:latest .
docker tag $username/swift-runtime:latest $username/swift-runtime:$tag
docker push $username/swift-runtime:latest
docker push $username/swift-runtime:$tag
docker push $username/swift:latest
docker push $username/swift:$tag