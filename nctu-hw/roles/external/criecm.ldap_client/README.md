# ldap_client

UNIX accounts via LDAP (nslcd) (Debian,FreeBSD)

## Variables (default)

### Mandatory
* `ldap_base` ('')
  ex: 'dc=univ,dc=fr'
* `ldap_uri` ('')
  ex: 'ldaps://ldapr.univ.fr/ ldaps://ldap.univ.fr/'

### Check default values:
* `ldap_force_shell` ('/usr/sbin/nologin')
  define it empty to allow shell from ldap, or force another
  (default is good if you only need accounts without allowing users to log in)
* `ldap_binddn` ('')
* `ldap_bindpw` ('')
* `ldap_tls_cacert` ('')
* `ldap_passwd_ou` ('ou=People')
* `ldap_group_ou` ('ou=Group')
* `ldap_passwd_filter` ('(objectClass=posixAccount)')
* `ldap_authz_filter` (`ldap_passwd_filter`)
* `ldap_group_filter` ('(objectClass=posixGroup)')
* `ldap_min_uid` (1000)
* `ldap_nss` (true)
* `ldap_starttls` (false)

### Optional
* `pam_ldap_services` ([]) - FreeBSD only - does nothing if empty
  you may need 'login', maybe 'sshd', 'imap', … whatever pam service you need
* `ldap_validnames` ('')
  see `man nslcd.conf`
* `ldap_autofs` (False)
  allow automount nss in nslcd.conf

## Example playbook

* For a login machine:
```
- hosts: mymachines
  roles:
    - criecm.ldap_client
  vars:
    ldap_base: dc=univ,dc=fr
    ldap_uri: 'ldaps://myldap.mydomain ldaps://myldapbackup.mydomain'

    x509_ca_path: /etc/ssl/myca.crt
    x509_ca_file: files/ca.crt
    ldap_tls_cacert: '{{x509_ca_path}}'
    ldap_tls_reqcert: 'demand'

    ldap_force_shell: /bin/bash
```

* For a mail server:
```
- hosts: mailsrv
  roles:
    - criecm.ldap_client
    - a mailserver role
  vars:
    ldap_base: dc=univ,dc=fr
    ldap_uri: 'ldaps://myldap.mydomain ldaps://myldapbackup.mydomain'

    x509_ca_path: /etc/ssl/myca.crt
    x509_ca_file: files/ca.crt
    ldap_tls_cacert: '{{x509_ca_path}}'
    ldap_tls_reqcert: 'demand'

    ldap_passwd_filter: ('(&(objectClass=inetMailRecipient)(mail=*@mydomain))')
    pam_ldap_services: [ dovecot, imap, submission ]
```
