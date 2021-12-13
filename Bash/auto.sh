#!/bin/bash

ansible-playbook /etc/ansible/DVWA.yml

sleep 75s

ansible-playbook /etc/ansible/elkplaybook.yml

sleep 75s

ansible-playbook /etc/ansible/filebeat-playbook.yml

sleep 90s

ansible-playbook /etc/ansible/metricbeat-playbook.yml
