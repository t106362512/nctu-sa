# criecm.nfs_server

NFS server

Will 
  * enable nfs daemons
  * enable nfsuserd to map uid<->uidnumbers
  * create exports blocks in /etc/exports for each share
    when share.nfsshares is not empty

Requirements
------------

Role Variables
--------------

* `shares` ([]): list of "share" dicts, with:
  * `path` ('') MANDATORY
  directory to share
  * `nfsshares` ([]) MANDATORY
  list of /etc/exports lines (without path)
* `mountd_add_flags ("-l")`
  flags to pass to mountd (man mountd)

Dependencies
------------

Example Playbook
----------------

    - hosts: servers
      roles:
         - criecm.nfs_server
      vars:
        shares:
          - name: "myshare"
            path: "/shares/t"
            nfsshares:
              - "-maproot=0 -network 2001:0DB8:fe43:ff44:/64"
              - "-network 192.0.2.0/24"

License
-------

BSD

