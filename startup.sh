#!/bin/bash

[ "$1" == "shell" ] \
    && while true; do bash; done

[ "$1" == "install" ] \
    && {
        true
    }

grep -q "#PUBLIC_IP#" /etc/keepalived/keepalived.conf \
    && {
        [ -n "$VIP" ] && \
            sed -i "s/#PUBLIC_IP#/$VIP/" /etc/keepalived/keepalived.conf
    }

grep -q "#PUBLIC_IFACE#" /etc/keepalived/keepalived.conf \
    && {
        IFACE=${IFACE:-eth0}
        sed -i "s/#PUBLIC_IFACE#/$IFACE/" /etc/keepalived/keepalived.conf
    }


[ -n "$MP" ] && {
    setfattr -x trusted.glusterfs.volume-id $MP >/dev/null 2>&1
    setfattr -x trusted.gfid $MP >/dev/null 2>&1
}

/usr/bin/supervisord -n
