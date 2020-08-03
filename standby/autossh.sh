#!/bin/sh
date
chmod 400 ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa.pub
apk add autossh
AUTOSSH_DEBUG=1 autossh -M 0 -N -4 -o StrictHostKeyChecking=no -o ServerAliveInterval=10 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -t -t -L 0.0.0.0:10000:0.0.0.0:5432 -p 22 -vvvv brandon@161.35.106.51
