################# Amazon Linux Hardening #########################################################################
# Owner: NUVYM
# Date: 01-jul-2021
# Contact: contato@nuvym.com
#          nuvym.com
#################################################################################################################
# This script makes some Amazon Linux hardening best practices on Kubernetes Worker Nodes  
#################################################################################################################
#!/bin/bash 
#################################################################################################################
############################### packages ########################################################################
sudo yum install -y nano.x86_64
sudo yum install -y amazon-efs-utils.noarch
sudo yum install -y telnet
#################################################################################################################
############################## ssh ##############################################################################
sudo groupadd sshaccess
sudo usermod ec2-user -a -G sshaccess
sudo curl -o /etc/ssh/sshd_config https://raw.githubusercontent.com/Adiel-Ribeiro/Amazon-Linux/master/sshd_config
sudo chmod 400 /etc/ssh/sshd_config
##################################################################################################################
################################ umask ###########################################################################
echo "umask 077" >> $HOME/.bashrc
sudo bash -c "echo umask 077 >> /root/.bashrc"
##################################################################################################################
########################## hosts #################################################################################
sudo bash -c "echo 10.0.0.153 fs-ee44db5a.efs.us-east-1.amazonaws.com >> /etc/hosts"
##################################################################################################################
##################################### fstab ######################################################################
sudo bash -c "echo fs-ee44db5a.efs.us-east-1.amazonaws.com:/ \
/nfs nfs defaults,_netdev,noresvport,intr,bg,noac,lookupcache=none,sync,noexec 0 0 \
>> /etc/fstab"
##################################################################################################################
####################################### efs ######################################################################
sudo mkdir /nfs 
sudo chmod 755 /nfs 
##################################################################################################################
################################### kubelet ######################################################################
sudo curl -o /etc/kubernetes/kubelet/kubelet-config.json \
https://raw.githubusercontent.com/Adiel-Ribeiro/Amazon-Linux/master/kubelet-config.json
sudo chmod 644 /etc/kubernetes/kubelet/kubelet-config.json
##################################################################################################################
################################### docker #######################################################################
sudo bash -c "echo ipv6=false >> /etc/sysconfig/docker"
sudo curl -o /usr/lib/systemd/system/docker.service \
https://raw.githubusercontent.com/Adiel-Ribeiro/Amazon-Linux/master/docker.service
sudo chmod 644 /usr/lib/systemd/system/docker.service
##################################################################################################################
####################################### sysctl ###################################################################
sudo curl -o /etc/sysctl.conf https://raw.githubusercontent.com/Adiel-Ribeiro/Amazon-Linux/master/sysctl.conf
sudo chmod 644 /etc/sysctl.conf 
##################################################################################################################
sudo reboot