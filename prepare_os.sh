#!/bin/bash

echo "Enter Password:"

read userPass

echo $userPass | sudo -S bash -c "echo '$USER ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$USER"

