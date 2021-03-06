#!/usr/bin/env bash

ME=$(basename "$0")

_DIRECTORY_TO_MIGRATE=${1:-empty}
_NFS_SHARE_LOCATION="/nfs"

ORIGIN_NFS_SERVER=10.10.0.2
DESTINATION_NFS_SERVER=10.10.0.3

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

list_nfs_share() {
    local NFS_SERVER="${1}"
    ssh $NFS_SERVER sudo ls $_NFS_SHARE_LOCATION
}

if [ "$_DIRECTORY_TO_MIGRATE" == "empty" ]; then
    display_usage
    exit 1
fi

if [ "$_DIRECTORY_TO_MIGRATE" == "list" ]; then
    list_nfs_share "$ORIGIN_NFS_SERVER"
    exit 1
fi

# Wrap up the directory to migrate
ssh $ORIGIN_NFS_SERVER sudo tar -cvzpf "$_DIRECTORY_TO_MIGRATE.tar.gz" "$_NFS_SHARE_LOCATION/$_DIRECTORY_TO_MIGRATE"

# Pull the data locally
scp $ORIGIN_NFS_SERVER:"$_DIRECTORY_TO_MIGRATE.tar.gz" "$_DIRECTORY_TO_MIGRATE.tar.gz"

# Push the data to the destination server
scp "$_DIRECTORY_TO_MIGRATE.tar.gz" $DESTINATION_NFS_SERVER:"$_DIRECTORY_TO_MIGRATE.tar.gz"

# Unwrap directory to migrate with same permissions and ownership
ssh $DESTINATION_NFS_SERVER sudo tar --same-owner -xvzpf "$_DIRECTORY_TO_MIGRATE.tar.gz" -C /

# Remove tar-balls from both origin and destination servers
ssh $DESTINATION_NFS_SERVER rm "$_DIRECTORY_TO_MIGRATE.tar.gz"
ssh $ORIGIN_NFS_SERVER rm -f "$_DIRECTORY_TO_MIGRATE.tar.gz"

echo
echo "Contents of $_NFS_SHARE_LOCATION on destination server:"
list_nfs_share "$DESTINATION_NFS_SERVER"

rm "$_DIRECTORY_TO_MIGRATE.tar.gz"
