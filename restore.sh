#!/bin/sh
supervisorctl stop slapd

LDAP_DATA_DIR=/var/lib/openldap/openldap-data
LDAP_BACKUP_FILE=$1
echo restore ldap data
rm -fr $LDAP_DATA_DIR/*
slapadd -l $LDAP_BACKUP_FILE
chown ldap:ldap -R $LDAP_DATA_DIR

supervisorctl start slapd
