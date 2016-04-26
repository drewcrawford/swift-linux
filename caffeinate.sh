if [ "$0" = "$BASH_SOURCE" ]; then
    echo "Run with source"
    exit 1
fi
export tag=caffeinated-$tag
cp swift-local.tar.gz linux-$tag.tar.gz