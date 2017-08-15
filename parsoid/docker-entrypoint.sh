#!/bin/bash

service parsoid restart

exec "$@"
