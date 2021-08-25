#!/usr/bin/env bash
# main startup script

# check if apt is ready
while fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
    echo "APT is not ready to be used, waiting..."
    sleep 5
done

repo="https://github.com/Yimura/Vultr-LavaLink-ServerPrep/archive/refs/heads/main.tar.gz"

wget $repo
tar xf main.tar.gz
cd Vultr-LavaLink-ServerPrep-main

chmod a+x ./*.sh

./docker.sh && ./ipv6.sh && ./lavalink.sh