#!/bin/bash

set -e

DOWNLOAD_URL='https://legacy-s1.apitable.com/docker-compose.tar.gz'

mkdir -p apitable
cd apitable || exit 1

: "${DOWNLOAD_URL?✗ missing env}"

curl -fLo docker-compose.tar.gz "${DOWNLOAD_URL}"
tar -xvzf docker-compose.tar.gz

docker-compose down -v --remove-orphans
for i in {1..50}; do
    if docker-compose pull; then
        if docker-compose up -d; then
            break
        fi
    fi
    sleep 6
done
