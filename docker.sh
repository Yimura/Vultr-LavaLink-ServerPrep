#!/usr/bin/env bash
# installs docker and docker-compose

echo "Installing docker from get.docker.com"
curl -fsSL https://get.docker.com | sh

echo "Installing docker-compose"
for i in {1..5}
do
    apt update && apt install docker-compose -y

    if [[ $? -ne 0 ]]; then
        echo "Failed to setup docker-compose, retrying..."

        sleep 1

        continue
    fi

    break
done