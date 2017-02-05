This repository contains simple administration scripts I use on my servers. 

# Handmade backup system (files+mysql databases) based on duplicity+percona-xtrabackup

- [duplicity.sh](admin-scripts/wiki/duplicity.sh): Performs encrypted, incremental backups of the specified directories to a remote server using [duplicity](http://duplicity.nongnu.org).

- [xtrabackup.sh](admin-scripts/wiki/Guide#xtrabackup): Performs backups of MySQL databases using [Percona's xtrabackup](http://www.percona.com/doc/percona-xtrabackup/). xtrabackup allows for faster, safe backups and restores than mysqldump while databases are in use. For more information, please check out [this blog post](http://vitobotta.com/painless-hot-backups-mysql-live-databases-percona-xtrabackup/ "Painless, ultra fast hot backups and restores of MySQL databases with Percona's XtraBackup").

- [.xtrabackup.config](admin-scripts/wiki/.xtrabackup.config): Config for xtrabackup.sh. Have to be placed to /root

- [.duplicity.config](admin-scripts/wiki/.duplicity.config): Config for duplicity.sh. Have to be placed to /root
