#!/usr/bin/env bash

# check if apt is ready
while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
    echo "APT is not ready to be used, waiting..."
    sleep 5
done

./docker.sh
./ipv6.sh
./lavalink.sh