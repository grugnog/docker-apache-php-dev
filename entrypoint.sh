#!/bin/bash
set -e

if [ "$USER_CREATE" ] && ! [ -d /home/$USER_CREATE ]; then
	useradd -m -s /bin/bash -G www-data $USER_CREATE
	echo "User $USER_CREATE is added"
	if [ "$USER_PASSWORD" ]; then
		echo "$USER_CREATE:$USER_PASSWORD" | chpasswd
		echo "Password is set for user \"$USER_CREATE\""
	fi
	if [ "$USER_PUBLIC_KEY" ]; then
		su $USER_CREATE -c "mkdir -p -m 0700 ~/.ssh"
		su $USER_CREATE -c "echo $USER_PUBLIC_KEY > ~/.ssh/authorized_keys"
		su $USER_CREATE -c "chmod 0600 ~/.ssh/authorized_keys"
		echo "Public key set for user \"$USER_CREATE\""
	fi
	if [ "$GIT_NAME" ]; then
		su $USER_CREATE -c "git config --global user.name \"$GIT_NAME\""
		echo "Git name is set to \"$GIT_NAME\""
	fi
	if [ "$GIT_EMAIL" ]; then
		su $USER_CREATE -c "git config --global user.email \"$GIT_EMAIL\""
		echo "Git email is set to \"$GIT_EMAIL\""
	fi
	chown $USER_CREATE /var/www
	echo "$USER_CREATE ALL=(root) NOPASSWD: ALL" > /etc/sudoers.d/$USER_CREATE
	chmod 0400 /etc/sudoers.d/$USER_CREATE
fi

unset USER_CREATE
unset USER_PASSWORD
unset USER_PUBLIC_KEY
unset GIT_NAME
unset GIT_EMAIL

exec "$@"
