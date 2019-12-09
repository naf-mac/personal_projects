#!/bin/bash
# https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#operating-system-and-distribution-variance

# pwd - myinfra

# Create non-directory files
# production - inventory file for production servers
# staging - inventory file for staging environment
# site.yml - master playbook
# webservers.yml - playbook for webserver tier
# dbservers.yml - playbook for dbserver tier
touch production staging site.yml webservers.yml dbaservers.yml

# library -  if any custom modules, put them here (optional)
# module_utils - if any custom module_utils to support modules, put them here (optional)
# filter_plugins - if any custom filter plugins, put them here (optional)
mkdir -p library/ module_utils/ filter_plugins/

mkdir group_vars host_vars
touch group_vars/group1.yml group_vars/group2.yml # here we assign variables to particular groups
touch host_vars/hostname1.yml host_vars/hostname2.yml # here we assign variables to particular systems

# common - this hierarchy represents a "role"
# webtier - same king of structure as "common" was above, done for the webtier role
mkdir -p roles/{common,webtier,monitoring,fooap}

cd roles
# library - roles can also include custom modules
# module_utils  - roles can also include custom module_utils
# lookup_plugins -  or other types of plugins, like lookup in this case
mkdir -p common/{tasks,handlers,templates,files,vars,defaults,meta,library,module_utils,lookup_plugins}

touch common/tasks/main.yml #  <-- tasks file can include smaller files if warranted
touch common/handlers/main.yml #  <-- handlers file

#  <-- files for use with the template resource
touch common/templates/ntp.conf.j2  #  <------- templates end in .j2

#  <-- files for use with the copy resource
#  <-- script files for use with the script resource
touch common/files/{bar.txt,foo.sh}

touch common/vars/main.yml #  <-- variables associated with this role
touch common/defaults/main.yml #  <-- default lower priority variables for this role
touch common/meta/main.yml #  <-- role dependencies
