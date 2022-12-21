# Openldap with restore scripts

The slapd must be stopped to restore from the ldif file output by slapcat.
Therefore, we developed a script that stops slapd and then restores it by letting supervisord control slapd.

## Environment Variable

```
LDAP_CONFIG_PASSWORD: root password for cn=config
```

## Backup

### Config

```
slapcat -b cn=config > $CONFIG_BACKUP_FILE
```

### Data

```
slapcat > $BACKUP_FILE
```

## Restore

### Config

```
/var/lib/openldap/restore-config.sh $CONFIG_BACKUP_FILE
```

### Data

```
/var/lib/openldap/restore.sh $BACKUP_FILE
```
