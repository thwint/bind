#!/bin/sh

# convert template using dockerize
dockerize -template /etc/bind/named.conf.tmpl:/etc/bind/named.conf
# start named as user named, run in foreground and log to stdout
named -g -u named
