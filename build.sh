set -e
username="drewcrawford"
echo "Type tag name"
read tag
WORKDIR=/tmp

sed "s/__TAG__/$tag/" Dockerfile > Dockerfile.tagged
docker build -f Dockerfile.tagged -t swift-tmp .
docker save swift-tmp > $WORKDIR/swift_tmp.tar
#figure out where to use from
FROM=`docker history -q swift-tmp | tail -n 3 | head -n 1`
PATH="/usr/local/opt/gnu-tar/libexec/gnubin:$PATH"
sudo docker-squash -from $FROM -i "$WORKDIR/swift_tmp.tar" -o "$WORKDIR/swift_squashed.tar" -t $username/swift:$tag
docker load -i $WORKDIR/swift_squashed.tar
docker tag $username/swift:$tag $username/swift:latest 
id=$(docker create drewcrawford/swift:latest)
docker cp $id:usr/local/lib/swift - > swiftlibs.tar
docker build -f Runtime.dockerfile -t $username/swift-runtime:latest .
docker tag $username/swift-runtime:latest $username/swift-runtime:$tag
docker push $username/swift-runtime:latest
docker push $username/swift-runtime:$tag
docker push $username/swift:latest
docker push $username/swift:$tag