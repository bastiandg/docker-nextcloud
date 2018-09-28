#!/usr/bin/env bash

set -eu -o pipefail

DOMAIN_NAME="example.net"
EMAIL="name@example.net"
DATADIR="/var/data/nextcloud"

password () {
	tr -cd '[:alnum:]' < /dev/urandom | fold -w30 | head -1
}

CONFIG="$DATADIR/config.env"
if [ ! -d "$DATADIR" ] ; then
	sudo mkdir -p "$DATADIR"
	sudo chown -R "$USER:$USER" "$DATADIR"
	cp -r volumes/* "$DATADIR"
	cp docker-compose.yml "$DATADIR"
	if [ ! -f "$CONFIG" ] ; then
		echo "export DOMAIN_NAME=\"$DOMAIN_NAME\"" > "$CONFIG"
		echo "export SERVER_NAME=\"$DOMAIN_NAME\"" >> "$CONFIG"
		echo "export EMAIL=\"$EMAIL\"" >> "$CONFIG"
		echo "export NEXTCLOUD_ADMIN_USER=\"root\"" >> "$CONFIG"
		echo "export NEXTCLOUD_ADMIN_PASSWORD=\"$(password)\"" >> "$CONFIG"
		echo "export DATADIR=\"$DATADIR\"" >> "$CONFIG"
		echo "export MYSQL_ROOT_PASSWORD=\"$(password)\"" >> "$CONFIG"
		echo "export MYSQL_DATABASE=\"nextcloud\"" >> "$CONFIG"
		echo "export MYSQL_PASSWORD=\"$(password)\"" >> "$CONFIG"
		echo "export MYSQL_USER=\"nextcloud\"" >> "$CONFIG"
	fi

	. "$CONFIG"
	sed -i \
		-e "s#ADMINUSER#$NEXTCLOUD_ADMIN_USER#g" \
		-e "s#ADMINPASS#$NEXTCLOUD_ADMIN_PASSWORD#g" \
		-e "s#MYSQL_ROOT_PASSWORD#$MYSQL_ROOT_PASSWORD#g" \
		-e "s#MYSQL_DATABASE#$MYSQL_DATABASE#g" \
		-e "s#MYSQL_PASSWORD#$MYSQL_PASSWORD#g" \
		-e "s#MYSQL_USER#$MYSQL_USER#g" \
		"$DATADIR/config/autoconfig.php"
	sudo chown -R 33:33 "$DATADIR/data"
	sudo chown -R 33:33 "$DATADIR/config"
	sudo chown -R 33:33 "$DATADIR/custom_apps"
fi

cd "$DATADIR"
. "$CONFIG"

# create nginx-proxy network
if ! docker network inspect nginx-proxy &> /dev/null ; then
	docker network create -d bridge nginx-proxy
fi

# run docker-compose to bring up the images
if ! which docker-compose ; then
	sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
fi

docker-compose up -d
