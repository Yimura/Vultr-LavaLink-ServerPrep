#!/usr/bin/env bash
# This script setups a ndp proxy on a systemd supported machine.
# It allows for a machine to use an entire subnet without it actually being assigned by a provider or cloud host.
# I am in no way responsible if this script cause problems with your machine.

script_path='/etc/ipv6.sh'
test -f $script_path > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "Creating startup script at $script_path"

    cat $BASH_SOURCE > $script_path
    chmod a+x $script_path

    echo "Creating service..."
    service_path='/etc/systemd/system/ip.service'
    echo "[Unit]
    Description=IPv6 NDPPD service

    [Service]
    User=root
    ExecStart=$script_path
    Restart=always

    [Install]
    WantedBy=multi-user.target" > $service_path

    echo "Starting service..."
    systemctl enable ip --now

    exit 0
fi

ndppd_config="/etc/ndppd.conf"
test -f $ndppd_config > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "IPv6 Setup script has already been ran before, starting service..."

    ipv6=$(curl -s6 http://icanhazip.com)

    echo 1 > /proc/sys/net/ipv6/ip_nonlocal_bind
    ip -6 route add local "$ipv6/64" dev lo

    exec ndppd
fi

ipv6=$(curl -s6 http://icanhazip.com)
if [[ $? -ne 0 ]]; then
    echo "Failed to curl over IPv6 to http://icanhazip.com, does this machine have an IPv6 subnet?"

    exit 1
fi

echo "IPv6 has been succesfully queried."

type -P ndppd > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
    echo "ndppd is not installed, installing..."

    apt update && apt install ndppd -y
fi

echo "Creating ndppd.conf"

nic=$(ip -o -4 route show to default | awk '{print $5}')
echo "Using NIC '$nic'"

echo "route-ttl 30000
proxy $nic {
    router yes
    timeout 500
    ttl 30000
    rule $ipv6/64 {
        static
    }
}" > $ndppd_config

echo "Enabling IPv6 non local binding..."

echo 1 > /proc/sys/net/ipv6/ip_nonlocal_bind
ip -6 route add local "$ipv6/64" dev lo

echo "Startin ndppd daemon"

exec ndppd
