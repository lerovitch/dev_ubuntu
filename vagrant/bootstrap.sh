#!/usr/bin/env bash
#
# Bootstrap the vagrant VM by installing Ansible and
# letting Ansible do the provisioning in local connection mode
#

# warning: heavily bodged and hardcoded bootsrtap script for Windows, this is for example / testing / further refinement only - not suitable for distribution

# we need to install Ansible so it can be run locally:  install the EPEL repo so Ansible can be installed via yum
# install ansible (latest version will do for now - TODO: push the latest rpm distributable into Artifactory and sync it down from there)
echo "...[INFO] Installing Ansible"

apt-get install -y software-properties-common
apt-add-repository ppa:ansible/ansible
apt-get update
apt-get install -y --force-yes ansible

# shared folder file permission issues mean everything under /vagrant has unchangeable executable permissions which breaks the Ansible inventory file -
#  so do some hacky file manipulation for the short-term - TODO: make this a /much/ more graceful process
echo "...[INFO] Setting up bootstrap filesystem structures"
mkdir ~/ansible

cd /vagrant

# Check to see if we are running from a project that is using the service specific playbook structure
if [ -d ./ansible/run ]; then
	echo "...[INFO] Project specific ansible run directory detected"
	cd ./ansible/run
fi

mkdir -p /vagrant/logs
tar -c . --exclude ".vagrant" --exclude "Vagrantfile" --exclude "logs" | tar -x -C ~/ansible
# set the permissions of all files under ansible/ to remove their executable permission
find ~/ansible -type f -exec chmod 0644 '{}' \;
#find ~/ansible -type d -exec chmod 0755 '{}' \;

# execute Ansible locally to run the setup playbook - as a quirk, Ansible will execute all tasks as the root user, which has implications
#  - need to temporarily disable the requiretty for the root user
echo "...[INFO] Writing < /etc/sudoers.d/root > to temporarily disable requiretty for root user - allows for successful Ansible execution"
echo 'Defaults:root !requiretty' > /etc/sudoers.d/root
cd ~/ansible
# write Ansible console output to a log file for reference / troubleshooting
LOG_DATE=`date +%Y%m%d_%H%M%S`
echo "...[INFO] Executing local Ansible run: < ansible-playbook server/dev.yml -i server/local --verbose --connection=local 2>&1 | tee /vagrant/logs/vagrant-ansible-$LOG_DATE.log >"
ansible-playbook server/dev.yml -i server/local --verbose --connection=local  2>&1 | tee /vagrant/logs/vagrant-ansible-$LOG_DATE.log ; result=${PIPESTATUS[0]}
# replace all the \n chars in the Ansible log with actual newlines
echo "...[INFO] Attempting to make the /vagrant/logs/vagrant-ansible-$LOG_DATE.log file more readable"
sed -i 's/\\n/\n/g' /vagrant/logs/vagrant-ansible-$LOG_DATE.log

# clean-up bootstrap apps / files
echo "...[INFO] Starting post-buildout clean-up"
cd ~
rm -rf ~/ansible
rm -rf /etc/sudoers.d/root
apt-get remove -y ansible

# show results of Ansible provisioning - for ansible exit statuses see: http://blog.cone.be/2014/06/12/ansible-exit-status/
if [ "$result" = "1" ]
then
  echo "...[ERROR] Ansible provisioning has FAILED with exit code < $result > (CONFIGURATION ERROR) - please check command line options, script arguments, playbook /task syntax, etc."
elif [ "$result" = "2" ]
then
  echo "...[ERROR] Ansible provisioning has FAILED with exit code < $result > (HOSTS FAILURE) - check log file for root cause < /vagrant/logs/vagrant-ansible-$LOG_DATE.log >"
elif [ "$result" = "3" ]
then
  echo "...[ERROR] Ansible provisioning has FAILED with exit code < $result > (DARK HOSTS) - please check all hosts are reachable"
else
  echo "...[INFO] Server provisioning completed successfully (or no hosts have been matched)"
fi
