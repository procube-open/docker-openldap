#!/bin/sh
CONFIG_CONF='/etc/openldap/slapd.d/cn=config/olcDatabase={0}config.ldif'
if [ -n "$LDAP_CONFIG_PASSWORD" ]; then
  HASHED_PASSWD=$(slappasswd -s "$LDAP_CONFIG_PASSWORD")
  if grep '^olcRootPW:' $CONFIG_CONF; then
    echo "reset olcRootPW in cn=config as ${HASHED_PASSWD}"
    sed -i -e "s/^olcRootPW: .*/olcRootPW: ${HASHED_PASSWD}/" $CONFIG_CONF
  else
    echo "add olcRootPW in cn=config as ${HASHED_PASSWD}"
    echo "olcRootPW: ${HASHED_PASSWD}" >> $CONFIG_CONF
  fi
fi
mkdir -p /run/openldap
chown ldap:ldap /run/openldap
exec /usr/sbin/slapd -h "ldap:/// ldapi:/// ldaps:///" -g ldap -u ldap -F /etc/openldap/slapd.d -d 1 
