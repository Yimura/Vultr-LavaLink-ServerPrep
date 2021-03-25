#!/usr/bin/env bash
# main startup script

repo="https://github.com/Yimura/Vultr-LavaLink-ServerPrep/archive/refs/heads/main.tar.gz"

wget $repo
tar xf main.tar.gz
cd Vultr-LavaLink-ServerPrep-main

chmod a+x ./*.sh

./ipv6.sh && ./docker.sh && ./lavalink.sh