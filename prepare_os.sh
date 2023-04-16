#!/bin/bash

echo "Enter Password:"

read userPass

echo $userPass | sudo -S bash -c "echo '$USER ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$USER"

sudo timedatectl set-timezone Asia/Novosibirsk

date

sed -i '/force_color_prompt=yes/s/#//' $HOME/.bashrc
source $HOME/.bashrc
