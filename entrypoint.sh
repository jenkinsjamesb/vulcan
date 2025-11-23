#!/bin/bash

# Start OpenSSH server
service ssh start

# Start lighttpd
service lighttpd start

# Start git daemon
git daemon --reuseaddr --base-path=/home/git /home/git &

# Monitor loop
tail -f /etc/issue