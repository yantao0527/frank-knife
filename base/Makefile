
use-rsa:
	-mkdir --mode=0700 $(HOME)/.ssh
	cp id_rsa id_rsa.pub $(HOME)/.ssh
	chmod 0400 $(HOME)/.ssh/id_rsa

new-rsa:
	ssh-keygen -t rsa
	
git-config:
	git config --global user.name frank
	git config --global user.email yantao0527@gmail.com
