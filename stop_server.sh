cd /terraform/ansible && ansible-playbook playbooks/backup.yml

cd /terraform/terraform && ./terraform destroy <<< yes
