#!/bin/bash
INCLUDE_VARS="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/vars.sh"
source $INCLUDE_VARS

# 該指令只適用於測試環境(只產出 rootca cert 和 key)
mkdir -p ${ROOTCA_QUICK_DIR}
openssl req \
    -config ${OPENSSL_CNF} \
    -new -x509 \
    -days 7305 \
    -extensions v3_ca \
    -keyout ${ROOTCA_QUICK_KEY} -out ${ROOTCA_QUICK_CERT}

chown ${USER} ${ROOTCA_QUICK_KEY}
chmod og-rwx ${ROOTCA_QUICK_KEY}

# 參考輸入
# Enter pass phrase for /etc/ssl/RootCA/private/1.nctu.cs.key.pem:
# You are about to be asked to enter information that will be incorporated
# into your certificate request.
# What you are about to enter is what is called a Distinguished Name or a DN.
# There are quite a few fields but you can leave some blank
# For some fields there will be a default value,
# If you enter '.', the field will be left blank.
# -----
# Country Name (2 letter code) []:TW
# State or Province Name (full name) []:Taiwan
# Locality Name (eg, city) []:HsinChu
# Organization Name (eg, company) []:NCTU
# Organizational Unit Name (eg, section) []:
# Common Name (eg, fully qualified host name) []:1.nctu.cs
# Email Address []:ChihChia4Wang@gmail.com
