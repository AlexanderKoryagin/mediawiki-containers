#!/usr/bin/env bash

KEYS_PATH='./custom_cfg/nginx/'

openssl \
    req -x509 \
    -nodes \
    -days 365 \
    -newkey rsa:2048 \
    -keyout ${KEYS_PATH}/nginx.key \
    -out ${KEYS_PATH}/nginx.crt

#openssl \
#    dhparam \
#    -out ${KEYS_PATH}/nginx.pem 2048
