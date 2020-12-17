#!/bin/sh

# Adding mac to the iptables chain
# echo "Excluding ip: $1"
/sbin/iptables -t mangle -D internet -m mac --mac-source $1 -j RETURN
