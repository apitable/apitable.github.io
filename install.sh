#!/bin/usr/env bash

set -e

notes () {
    cat << EOF
======== WARM TIPS ========
Before you submit any github issue, please do the following check:
* make sure the docker daemon is running
* make sure you use docker compose v2: recommend 2.x.x, got $(docker compose version --short 2>/dev/null || echo not install)
* check your internet connection if timeout happens
* check for potential port conflicts if you have local services listening on all interfaces (e.g. another redis container listening on *:6379)
===========================
EOF
}

trap notes ERR

if ! docker info >/dev/null 2>&1; then
     echo "Docker daemon or Docker Desktop is not running... please check" 2>&1
     false
     exit 1
fi

DOWNLOAD_URL='https://github.com/apitable/apitable.github.io/releases/latest/download/docker-compose.tar.gz'

mkdir -p apitable
cd apitable || exit 1

: "${DOWNLOAD_URL?✗ missing env}"

curl -fLo docker-compose.tar.gz "${DOWNLOAD_URL}"
tar -xvzf docker-compose.tar.gz

docker compose down -v --remove-orphans
for i in {1..50}; do
    if docker compose pull; then
        if docker compose up -d; then
            break
        fi
    fi
    sleep 6
done
