#!/bin/bash

# Setup git-shell-commands
cp -r /etc/git-shell-commands /home/git
chmod a+rx /home/git/git-shell-commands --recursive

# Start OpenSSH server
service ssh start

# Start lighttpd
service lighttpd start

# Monitor loop
tail -f /etc/issue