#!/bin/bash
set -e

if [ "$USER_CREATE" ] && ! id -u "$USER_CREATE" > /dev/null 2>&1; then
	if [ "$USER_ID" ]; then
		useradd -d /var/www -s /bin/bash -u $USER_ID $USER_CREATE
	else
		useradd -d /var/www -s /bin/bash $USER_CREATE
	fi
	chown ${USER_CREATE}. /var/www
	su $USER_CREATE -c "cp /etc/skel/{.bash_logout,.bashrc,.profile} ~/"
	echo "User $USER_CREATE is added"
	if [ "$USER_PASSWORD" ]; then
		echo "$USER_CREATE:$USER_PASSWORD" | chpasswd
		echo "Password is set for user \"$USER_CREATE\""
	fi
	if [ "$USER_PUBLIC_KEY" ]; then
		su $USER_CREATE -c "mkdir -p -m 0700 ~/.ssh"
		su $USER_CREATE -c "echo $USER_PUBLIC_KEY >> ~/.ssh/authorized_keys"
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
	echo "$USER_CREATE ALL=(root) NOPASSWD: ALL" > /etc/sudoers.d/$USER_CREATE
	chmod 0400 /etc/sudoers.d/$USER_CREATE
        sed -i -e "s/^export APACHE_RUN_USER=.*/export APACHE_RUN_USER=$USER_CREATE/" \
               -e "s/^export APACHE_RUN_GROUP=.*/export APACHE_RUN_GROUP=$USER_CREATE/" \
               /etc/apache2/envvars
fi

unset USER_CREATE
unset USER_PASSWORD
unset USER_PUBLIC_KEY
unset GIT_NAME
unset GIT_EMAIL

exec "$@"
