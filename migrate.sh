#!/usr/bin/env bash

ME=$(basename "$0")

directory=${1:-empty}

origin=10.10.0.2
destination=10.10.0.3

display_usage() {
    echo "usage:"
    echo "  $ME [list] [directory]"
    echo
    echo "examples:"
    echo
    echo "  $ME list"
    echo "      website-dev"
    echo "      website-prod"
    echo "      it-api-blog-comments-dev"
    echo "      it-api-blog-comments-prod"
    echo "      dashboard-search"
    echo "      faas"
    echo "      test"
    echo 
    echo "  $ME dashboard-search" 
    echo
}

if [ "$directory" == "empty" ]; then
    display_usage
    exit 1
fi

if [ "$directory" == "list" ]; then
    ssh $origin sudo ls /nfs
    exit 1
fi

ssh $origin sudo tar -cvzpf "$directory.tar.gz" "/nfs/$directory"

scp $origin:"$directory.tar.gz" "$directory.tar.gz"

scp "$directory.tar.gz" $destination:"$directory.tar.gz"

ssh $destination sudo tar --same-owner -xvzpf "$directory.tar.gz" -C /
ssh $destination rm "$directory.tar.gz"
ssh $origin rm -f "$directory.tar.gz"

echo
echo "Contents of /nfs on destination server:"
ssh $destination ls /nfs

rm "$directory.tar.gz"
