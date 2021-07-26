#!/bin/bash
INCLUDE_VARS="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/vars.sh"
source $INCLUDE_VARS

# 使用 rootca 的私鑰建立 rootca 的 req csr
openssl req -new -key ${ROOTCA_PRIVATE_KEY} -out ${ROOTCA_PUBLIC_PEQ_CSR}
chmod og-rwx ${ROOTCA_PUBLIC_PEQ_CSR}

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

# Please enter the following 'extra' attributes
# to be sent with your certificate request
# A challenge password []:
