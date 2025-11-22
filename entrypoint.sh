#!/bin/bash

# Start OpenSSH server
service ssh start

# Start lighttpd
service lighttpd start

# Monitor loop
tail -f /etc/issue