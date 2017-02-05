#!/bin/sh
mailfrom=<Email From address>
mailto=<Email To address>
HOME=/root
tmp_mail=/tmp/email
sender=`which sendmail`
dupli=`which duplicity`
repo=`cat /root/.duplicity.config | grep -m 1 BACKUPS_REPOSITORY | sed 's/BACKUPS_REPOSITORY=//g' |  sed -e 's|["'\'']||g'`

echo "Incremental backup started on `hostname` at `date +"%Y-%m-%d %H:%M:%S"`." > $tmp_mail
echo "Output follows" >> $tmp_mail
echo >> $tmp_mail

/root/backup/xtrabackup.sh incr >> /var/log/db-backup.log 2>&1
/root/backup/duplicity.sh incr >> /var/log/backup.log 2>&1

echo "MySQL backup status is:" >> $tmp_mail
echo >> $tmp_mail
/root/backup/xtrabackup.sh list >> $tmp_mail
echo "=====================================================" >> $tmp_mail
echo >> $tmp_mail
echo "Files backup status is:" >> $tmp_mail
echo >> $tmp_mail

$dupli collection-status $repo >> $tmp_mail

echo "Incremental backup ended on `hostname` at `date +"%Y-%m-%d %H:%M:%S"`." >> $tmp_mail

message=`cat $tmp_mail`

(
echo "From: $mailfrom";
echo "To: $mailto";
echo "Subject: "Incremental backup ended on `hostname` at `date +"%Y-%m-%d %H:%M:%S"`."";
echo "Content-Type: text/plain; charset=UTF-8";
echo "MIME-Version: 1.0";
echo "";
echo "${message}";
) | $sender -t
