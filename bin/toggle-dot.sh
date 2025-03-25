#!/usr/bin/env bash

CONFIG_PATH=/etc/systemd/resolved.conf.d/dns.conf

PRE=''
POST=''

MESSAGE=''

for pattern in {'DNS=','DNSOverTLS='}; do
    if (($(grep --count "^#${pattern}" "$CONFIG_PATH") > 0)); then
        PRE='#'
        POST=''
        MESSAGE='[V] DOT has been enabled'
    else
        PRE=''
        POST='#'
        MESSAGE='[X] DOT has been disabled'
    fi

    sudo sed -i "s|^${PRE}${pattern}|${POST}${pattern}|" "$CONFIG_PATH"
done

sudo systemctl restart systemd-resolved.service

echo "$MESSAGE"
