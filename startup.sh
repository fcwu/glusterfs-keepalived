#!/bin/bash

[ "$1" == "shell" ] \
    && while true; do bash; done

[ "$1" == "install" ] \
    && {
        true
    }

grep -q "#PUBLIC_IP#" /etc/keepalived/keepalived.conf \
    && {
        [ -z "$VIP" ] && exit 0
        sed -i "s/#PUBLIC_IP#/$VIP/" /etc/keepalived/keepalived.conf
    }

/usr/bin/supervisord -n
