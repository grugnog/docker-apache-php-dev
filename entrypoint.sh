#!/bin/bash
set -e

if [ "$DEV_USER" ]; then
	useradd -m -s /bin/bash -G sudo $DEV_USER
	echo "User $DEV_USER is added"
	if [ "$DEV_PASSWORD" ]; then
		echo "$DEV_USER:$DEV_PASSWORD" | chpasswd
		echo "Password is set"
	fi
	if [ "$GIT_NAME" ]; then
		su $DEV_USER -c "git config --global user.name \"$GIT_NAME\""
		echo "Git name is set"
	fi
	if [ "$GIT_EMAIL" ]; then
		su $DEV_USER -c "git config --global user.email \"$GIT_EMAIL\""
		echo "Git email is set"
	fi
	chown $DEV_USER /var/www
fi

exec "$@"
