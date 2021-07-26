# MariaDB

Setup mariadb on FreeBSD host

Using `include_role/tasks_from: db.yml` creates a single db+user

## Role Variables (default value)

* `mariadb_admin_user`: (admin)
* `mariadb_admin_password`: ''
  You *need* to set this one
* `mariadb_root_password`: ''
  Local access only / remote disabled
* `mariadb_socket`: (/tmp/mysql.sock)
* `mariadb_version`: (10.2)
  Version to install if not already installed (or to upgrade to if `do_upgrade_mariadb==True`)
* `mariadb_basedir`: (/var/db/mysql)
* `mariadb_logdir`: (/var/log/mysql)
* `mariadb_owner`: (mysql)
* `mariadb_group`: (mysql)
* `mariadb_zfs_base`: ('')
  if any, will create/set recordsize to 16K and create innodb-logs subdir (128K)
* `mariadb_users`: ([])
  Users to be created, dict with keys 'priv','name','password' and 'host'
  password won't be updated, only set at creation
  ( like in [mysql_user module](http://docs.ansible.com/ansible/latest/mysql_user_module.html "mysql_user module") )
* `mariadb_maintenance_users`: ([])
  like above, but to be defined globally
* `mariadb_dbs`: ([])
  List of databases to create (dict with keys 'name')
* `mariadb_config: ({})`
  Dict of config directives to be inserted in server ini file

## one-shot (CLI) variables
* `mariadb_relayout_zfs` (False)
  If defined (on command-line!), will change data layout for ZFS use
* `do_upgrade_mariadb` (False)
  If defined (CLI), upgrade mariadb packages to wanted/latest version

## Example Playbooks

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    # install / create db's from `mariadb_dbs` and users from `mariadb_users` and `mariadb_maintenance_users`
    - hosts: servers
      roles:
         - { role: criecm.mariadb, mariadb_admin_password: '42', mariadb_zfs_base: 'zdata/mariadb' }

    # just create a single database (the main task have already been run on the host(s))
    - hosts: dbservers
      include_role:
        name: criecm.mariadb
	tasks_from: db.yml
      vars:
        mariadb: { name: mydatabase, user: myuser, pass: hispass, fromhost: mywebsrv.my.domain, priv: 'mydatabase.*:ALL' }
      # you'll find a generated password in `db_pass` fact if not provided
## License

BSD
