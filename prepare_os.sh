#!/bin/bash

echo "Enter Password:"

read userPass
echo "Sudo without password"
echo $userPass | sudo -S bash -c "echo '$USER ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/$USER"

sleep 1

echo "Set timezone"
sudo timedatectl set-timezone Asia/Novosibirsk

date

sleep 1

echo "Enable color prompt"
sed -i '/force_color_prompt=yes/s/#//' $HOME/.bashrc
source $HOME/.bashrc

sleep 1

echo "Add script to cron"
crontab -l > $HOME/prepare
echo '@reboot sh $HOME/prepare.sh' >> $HOME/prepare
crontab $HOME/prepare
rm $HOME/prepare

sleep 1

echo "Start upgrade: `date`" > $HOME/check
sudo apt update; sudo apt full-upgrade -y
echo "Stop upgrade: `date`" >> $HOME/check

sleep 1

echo "Create ssh-key and add to authorized_key"
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
echo '
Host *
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null
' > $HOME/.ssh/config

sleep 1
#-------------------------------------------------------

echo '#!/bin/bash
crontab -l > $HOME/prepare
echo '' > $HOME/prepare
crontab $HOME/prepare
rm $HOME/prepare

echo "Start install Ansible: `date`" > $HOME/check

mkdir $HOME/ansible

echo '127.0.0.1' > $HOME/ansible/hosts
echo '
[defaults]
host_key_checking = False
inventory=$HOME/ansible/hosts
' > $HOME/ansible/ansible.cfg
#------------------------------------------------------
sudo apt install python3-pip -y
pip install ansible

cd $HOME/ansible
wget https://raw.githubusercontent.com/svkulygin/preparation/main/playbook.yaml >> $HOME/check
ansible-playbook playbook.yaml

echo "Stop install Ansible: `date`" >> $HOME/check
' > $HOME/prepare.sh && sudo reboot
