#!/bin/sh
supervisorctl stop slapd

LDAP_CONFIG_BACKUP_FILE=$1
echo restore ldap config
rm -fr /etc/openldap/slapd.d/*
slapadd -n0 -F /etc/openldap/slapd.d -l $LDAP_CONFIG_BACKUP_FILE
chown ldap:ldap -R /etc/openldap/slapd.d

supervisorctl start slapd
