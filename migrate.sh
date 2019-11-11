#!/usr/bin/env bash

ME=$(basename "$0")

_DIRECTORY_TO_MIGRATE=${1:-empty}
_NFS_SHARE_LOCATION="/nfs"

ORIGIN_NFS_SERVER=10.10.0.2
DESSTINATION_NFS_SERVER=10.10.0.3

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

if [ "$_DIRECTORY_TO_MIGRATE" == "empty" ]; then
    display_usage
    exit 1
fi

if [ "$_DIRECTORY_TO_MIGRATE" == "list" ]; then
    ssh $ORIGIN_NFS_SERVER sudo ls $_NFS_SHARE_LOCATION
    exit 1
fi

ssh $ORIGIN_NFS_SERVER sudo tar -cvzpf "$_DIRECTORY_TO_MIGRATE.tar.gz" "$_NFS_SHARE_LOCATION/$_DIRECTORY_TO_MIGRATE"

scp $ORIGIN_NFS_SERVER:"$_DIRECTORY_TO_MIGRATE.tar.gz" "$_DIRECTORY_TO_MIGRATE.tar.gz"

scp "$_DIRECTORY_TO_MIGRATE.tar.gz" $DESSTINATION_NFS_SERVER:"$_DIRECTORY_TO_MIGRATE.tar.gz"

ssh $DESSTINATION_NFS_SERVER sudo tar --same-owner -xvzpf "$_DIRECTORY_TO_MIGRATE.tar.gz" -C /
ssh $DESSTINATION_NFS_SERVER rm "$_DIRECTORY_TO_MIGRATE.tar.gz"
ssh $ORIGIN_NFS_SERVER rm -f "$_DIRECTORY_TO_MIGRATE.tar.gz"

echo
echo "Contents of $_NFS_SHARE_LOCATION on destination server:"
ssh $DESSTINATION_NFS_SERVER ls $_NFS_SHARE_LOCATION

rm "$_DIRECTORY_TO_MIGRATE.tar.gz"
