#!/bin/sh
ftp_log="$(date) ${UPLOAD_USER} has upload file ${1} with size ${UPLOAD_SIZE}" 
echo "${ftp_log}" >> /var/log/uploadscript.log

user_dir="/home/${UPLOAD_USER}"
upload_dir="/vol/web_hosting/${user_dir}/public_html"
! [ -f "${upload_dir}" ] && mkdir -p "${upload_dir}"
echo "${ftp_log}" >> "${upload_dir}/uploadscript.log"