set -e
username="drewcrawford"
echo "Type tag name"
read tag
export tag
export username

bash build-swift.sh
bash build-swift-local.sh
bash build-swift-image.sh
bash build-swift-runtime.sh
bash publish.sh