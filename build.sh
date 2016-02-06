set -e
username="drewcrawford"
echo "Type tag name"
read tag
WORKDIR=/tmp

sed "s/__TAG__/$tag/" build.dockerfile > Dockerfile.tagged
docker build -f Dockerfile.tagged -t swift-tmp .
echo "Moving swift.tar.gz to new container..."
id=$(docker create swift-tmp)
docker cp $id:/tmp/swift.tar.gz .
rm -rf fakeroot
mkdir -p fakeroot/usr/local
tar xf swift.tar.gz -C fakeroot/usr/local --strip-components 1
tar cf swift-local.tar.gz -C fakeroot .
rm -rf fakeroot
docker build -f swift.dockerfile -t $username/swift:$tag .
docker tag $username/swift:$tag $username/swift:latest 
echo "Building runtime image..."
id=$(docker create drewcrawford/swift:latest)
docker cp $id:usr/local/lib/swift - > swiftlibs.tar
docker build -f Runtime.dockerfile -t $username/swift-runtime:latest .
docker tag $username/swift-runtime:latest $username/swift-runtime:$tag
docker push $username/swift-runtime:latest
docker push $username/swift-runtime:$tag
docker push $username/swift:latest
docker push $username/swift:$tag