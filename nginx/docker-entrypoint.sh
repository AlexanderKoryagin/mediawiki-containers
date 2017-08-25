#!/bin/bash

rm -rf /etc/nginx/conf.d/default.conf
envsubst '$SERVER_NAME' < /etc/nginx/conf.d/mediawiki.template > /etc/nginx/conf.d/mediawiki.conf
nginx -g 'daemon off;'

exec "$@"
