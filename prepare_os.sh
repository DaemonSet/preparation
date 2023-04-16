#!/bin/bash

echo "Enter Password: "

read userPass

echo -e "$userPass" | sudo -S echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USER
