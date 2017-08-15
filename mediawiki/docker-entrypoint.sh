#!/bin/bash

set -e
set -u
set -x

: ${MEDIAWIKI_DB_SCHEMA:=mediawiki}
: ${MEDIAWIKI_DB_NAME:=mediawiki}
: ${MEDIAWIKI_DB_PORT:=3306}
: ${MEDIAWIKI_DB_USER:=root}
: ${MEDIAWIKI_DB_TYPE:=mysql}


# Wait for the DB to come up
while [ `/bin/nc -w 1 ${MEDIAWIKI_DB_HOST} ${MEDIAWIKI_DB_PORT} < /dev/null > /dev/null; echo $?` != 0 ]; do
    echo "Waiting for database to come up at ${MEDIAWIKI_DB_HOST}:${MEDIAWIKI_DB_PORT}..."
    sleep 1
done


# If there is no LocalSettings.php, create one using maintenance/install.php
if [ ! -e "LocalSettings.php" ]; then
	php maintenance/install.php \
		--confpath $(pwd) \
		--dbname "${MEDIAWIKI_DB_NAME}" \
		--dbschema "${MEDIAWIKI_DB_SCHEMA}" \
		--dbport "${MEDIAWIKI_DB_PORT}" \
		--dbserver "${MEDIAWIKI_DB_HOST}" \
		--dbtype "${MEDIAWIKI_DB_TYPE}" \
		--dbuser "${MEDIAWIKI_DB_USER}" \
		--dbpass "${MEDIAWIKI_DB_PASSWORD}" \
		--installdbuser "${MEDIAWIKI_DB_USER}" \
		--installdbpass "${MEDIAWIKI_DB_PASSWORD}" \
		--server "${MEDIAWIKI_SITE_SERVER}" \
		--scriptpath "/wiki" \
		--lang "${MEDIAWIKI_SITE_LANG}" \
		--pass "${MEDIAWIKI_ADMIN_PASS}" \
		"${MEDIAWIKI_SITE_NAME}" \
		"${MEDIAWIKI_ADMIN_USER}"

        # Append inclusion of CustomSettings.php
        echo "@include('/conf/CustomSettings.php');" >> LocalSettings.php

fi

# If LocalSettings.php exists, then attempt to run the update.php maintenance
# script. If already up to date, it won't do anything, otherwise it will
# migrate the database if necessary on container startup. It also will
# verify the database connection is working.
if [ -e "LocalSettings.php" -a "${MEDIAWIKI_UPDATE}" = 'true' ]; then
	echo >&2 'info: Running maintenance/update.php';
	php maintenance/update.php --quick --conf ./LocalSettings.php
fi

# Fix file ownership and permissions
chown -R www-data:www-data images/
chmod 755 images

exec "$@"
