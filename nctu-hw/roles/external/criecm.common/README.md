# common - base system role

* CA x509
* client OpenLDAP + config
* config mail relay (only `is_mailrelay == False and mailrelay != ''`)
  * Debian: postfix
  * FreeBSD: sendmail
  * OpenBSD: smtpd
* lignes de config sshd (en variables, voir defaults/main.yml)
* syslog centralisé:
  * sauf si `is_syslogd=True`
  * seulement si `syslog_server` existe
* deploiement des cles ssh `files/cles_ssh/*.pub`
* /usr/local/admin/sysutils/common depuis GIT (et plus selon variables)
* cron daily/weekly ecm (et supression des anciens de CVS)
* snmpd (TODO: Debian et OpenBSD)
* preferred shell pour root + it's config + aliases
* packages supplementaires (variable `pkgs`)

## templates and files

### sshd config and authorized keys

  * Files matching `cles_ssh/*.pub` will be authorized on root account
  * Files matching `cles_ssh/*.del` will be removed
  * vimrc file in files/ will be installed as /root/.vimrc

### ssh keys

  * Files matching `{{ playbook_dir }}/files/ssh/{{ inventory_hostname }}/ssh_host.*_key(.pub)?`
    will be installed on host's ssh daemon.

## Variables

  * `host_timezone` (Europe/Paris)
  * `is_resolver` (False)
    if True, will use 127.0.0.1 in resolv.conf first
  * `resolvers` ( [{ network='0.0.0.0/0', ip='8.8.8.8' }] )
    list of dicts, ip will be used if host match network (in listed order)
  * `dns64_resolvers ([])`
    for IP6-only hosts, overrides `resolvers` mechanism with DNS64-enabled resolvers
  * `rootmailto` ()
    mail to forward root's mail
  * `gits_root` ('/root')
    path for relative path in `gits`
  * `gits_group ('')`
    group to own gits_root
  * `gits_mode ('0750')`
    dir mode for gits_root
  * `gits`, `host_gits`, `group_gits` and `role_gits` ([])
    lists of dicts: each MUST have at least
      * `repo`: git url to clone there
      * `dest`: destination path (absolute or relative to gits_root)
    and MAY have:
      * `umask` ('0022')
      * `update` (False)
      * `version` (master)
  * `crons`,`host_crons`,`role_crons`:
    list of dicts for cron module
  * `ocsinventory_server` ('')
    If present, install and configure openinventory-agent
  * `root_shell` (zsh)
    Set your preferred one here :) (or set it empty to skip all this)
    put your rc file in {{ playbook_dir }}/files/{{ root_shell }}rc
  * `do_smart (True if not jail/vm)`
    configure smartd for disks alerts
  * `smart_mailto ('')`
    Here comes your email address if you wish to receive alerts by mail
  * `backup_dir (files/backups/{{ inventory_hostname }})`
    copy ssh host keys and restore /root/ files from here if any

### FreeBSD specific

  * `pkg_repo_conf` (pkgecm.conf)
    name of a pkg repo config file to be installed first
  * `is_jail` (False)
    if True, will skip hardware monitoring tools (smart, ipmi, snmp, dmidecode)
  * `freebsd_base_pkgs ([git,rsync,vim-console,root_shell])`
    list of packages to install

### OpenBSD specific

  * `openbsd_base_pkgs ([git,rsync,vim--no_x11,root_shell])`
    list of packages to install
  * `openbsd_pkg_mirror ("http://ftp.openbsd.org")`
    mirror to use

## Debian specific

  * `debian_base_pkgs (git,rsync,vim,root_shell])`
    list of packages to install

### Packages

  * `pkgs` ([])
    additionnal packages to install using distribution's package system
  * `host_pkgs` `role_pkgs` ([])
    other packages defined in inventory or roles (or whatever)

### Syslog

  * `syslog_server` ()
    If defined, all logs will be send there
  * `syslog_auth_server` (`syslog_server`)
    Auth logs will be send there

### x509

  * `x509_ca_file` ('')
    source file for x509 AC certificate(s)
  * `x509_ca_path` (/etc/ssl/ca.crt)
    dest path for above cert file

### Mailrelay
  * `is_mailrelay` (False)
    Does not configure mail relay if True
  * `mailrelay` ()
    If defined, name/IP of the mail relay

### Ssh
  * `sshd_allow_groups` ('')
    define AllowGroups in `/etc/ssh/sshd_config`

### LDAP basic config
  * `ldap_base` ('')
    baseDN ldap (for ldap.conf)
  * `ldap_uri` ('ldaps://ldapr.univ.fr/ ldaps://ldap.univ.fr/')
    URI for ldap.conf
  * `ldap_tls_reqcert` (never)
    value for same name in ldap.conf

### Network Time Protocol (ntp)

If any of `ntp_servers` or `ntp_pools` is non-empty
  the role will take care of ntp(d).conf and ntp service
  * `ntp_servers` ([])
    list of ntp servers
  * `ntp_pools` ([])
    list of ntp pools
  * `ntp_listen_addrs` ([])
    IP's to listen to (OpenBSD won't listen anywhere without it, can be '*')
