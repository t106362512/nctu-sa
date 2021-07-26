#!/bin/bash
INCLUDE_VARS="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/vars.sh"
source $INCLUDE_VARS

# 建立 rootca certs 資料夾
mkdir -p ${ROOTCA_PUBLIC_CERT_DIR}

# 使用 rootca 的申請請求檔(.csr)來自簽一個 rootca.
# 該步驟是為了測試使用，prod 的話則會把 .csr 丟給憑證中心簽署.
openssl x509 -req -days 7305 -sha512 \
 -extfile ${OPENSSL_CNF} -extensions v3_ca \
 -signkey ${ROOTCA_PRIVATE_KEY} \
 -in ${ROOTCA_PUBLIC_PEQ_CSR} \
 -out ${ROOTCA_PUBLIC_CERT_CRT}
chmod og-rwx ${ROOTCA_PUBLIC_CERT_CRT}
