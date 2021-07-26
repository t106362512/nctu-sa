#!/bin/sh
ftp_log="$(date) ${UPLOAD_USER} has upload file ${1} with size ${UPLOAD_SIZE}" 
echo "${ftp_log}" >> /var/log/uploadscript.log
