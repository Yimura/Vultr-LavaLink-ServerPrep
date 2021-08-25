#!/usr/bin/env bash
# this script creates a docker-compose.yml file and application.yml
# this way our LavaLink can be setup in one go without user interaction

ipv6=$(curl -s6 http://icanhazip.com)
password=$(hexdump -n 16 -e '4/4 "%08X" 1 "\n"' /dev/random)

sed -i "s/yourPasswordHere/$password/" application.example.yml
sed -i "s/theIp64RangeHere/$ipv6\/64/" application.example.yml

mv application.example.yml application.yml
mv docker-compose.example.yml docker-compose.yml

docker-compose up -d