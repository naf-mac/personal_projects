#!/bin/bash
# This layout gives you more flexibility for larger environments, as well as
# a total separation of inventory variables between different environments.
# The downside is that it is harder to maintain, because there are more files.
# https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#operating-system-and-distribution-variance

# pwd - myinfra

touch site.yml webservers.yml dbaservers.yml
mkdir -p library/ module_utils/ filter_plugins/ roles/{common,webtier,monitoring,fooap}

# production
mkdir -p inventories/production/{group_vars,host_vars}
cd inventories/production/
touch hosts     # inventory file for production servers
touch group_vars/group1.yml group_vars/group2.yml # here we assign variables to particular groups
touch host_vars/hostname1.yml host_vars/hostname2.yml # here we assign variables to particular systems

# staging
mkdir -p /home/ansiadm/myinfra/inventories/staging/{group_vars,host_vars}
cd ../staging
touch hosts
touch group_vars/group1.yml group_vars/group2.yml
touch host_vars/staginghost1.yml host_vars/staginghost2.yml
