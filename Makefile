provision:
	ansible-playbook ansible/provision.yml --inventory=ansible/production --ask-vault-pass

deploy:
	ansible-playbook ansible/deploy.yml --inventory=ansible/production --ask-vault-pass
