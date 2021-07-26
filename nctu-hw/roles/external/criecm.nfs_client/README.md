# nfs_client

NFS (v3+v4) client
ports fixes (FreeBSD,Debian)

## variables (default)

### mandatory
none

### optionnal (default value)

Fix lockd/statd/nfscbcd ports:
* `statd_port` (4047)
* `lockd_port` (4045)
* `nfsccb_port` (4048)

* `idmap_domain` ()
    if you need user names mapping

For LDAP/autofs
* `ldap_autofs` (False) If true, deploy LDAP autofs maps
* `ldap_autofs_master_map`
  if defined (eg: "auto.master"), calls `criecm.ldap_client` for nss part
  and use LDAP-based automount (you need some vars for him too, see README.md)
* `ldap_autofs_ou` ('ou=automount,')
* `ldap_autofs_value_attr` ('nisMapEntry')
* `ldap_autofs_mapname_attr` ('nisMapName')
* `ldap_autofs_entry_attr` ('cn')
* `ldap_autofs_transform` ('') inline command to transform mount options on FreeBSD only

## Dependencies

If using ldap autofs, we'll depend on `criecm.ldap_client`


## Sample playbooks
```
# simple
- hosts: machines
  roles:
    - criecm.nfs_client

# with autofs
- hosts: others
  roles:
    - criecm.nfs_client
  vars:
    ldap_autofs: True
    ldap_autofs_master_map: auto.master
    ldap_base: dc=my,dc=org
    ldap_binddn: cn=myadmin,ou=context
    ldap_bindpw: mypass
    ldap_uris: ldaps://ldapr.my.org

```

## LDAP/autofs howto

Just define `ldap_autofs: True` and `ldap_autofs_master_map: auto.master` with the example below in LDAP:

default values will work 
with this kind of ldap records:

```
# auto.master glue
dn: nisMapName=auto.master,ou=automount,dc=example,dc=com
nisMapName: auto.master
objectClass: nisMap
objectClass: top

# /home	auto.home
dn: cn=/home,nisMapName=auto.master,ou=automount,dc=example,dc=com
cn: /home
objectClass: nisObject
nisMapName: auto.master
nisMapEntry: auto.users

# auto.home glue
dn: nisMapName=auto.users,ou=automount,dc=example,dc=com
objectClass: top
objectClass: nisMap
nisMapName: auto.users

# info	-fstype=nfs,rw	filer:/srv/info
dn: cn=info,nisMapName=auto.users,ou=automount,dc=example,dc=com
objectClass: nisObject
nisMapName: auto.users
cn: info
nisMapEntry: -fstype=nfs,rw filer:/srv/info
```


