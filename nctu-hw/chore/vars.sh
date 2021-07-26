#!/bin/bash
ROOTCA_NAME=1.nctu.cs
ROOTCA_DIR=/etc/ssl/RootCA
OPENSSL_CNF=/etc/ssl/openssl.cnf #建立 cert 出錯時，可參考 openssl.cnf 添加 v3_ca

# 該變數之檔案不可外流
ROOTCA_PRIVATE_DIR=${ROOTCA_DIR}/private
ROOTCA_PRIVATE_RND=${ROOTCA_PRIVATE_DIR}/.rnd
ROOTCA_PRIVATE_KEY=${ROOTCA_PRIVATE_DIR}/${ROOTCA_NAME}.key.pem

# 該變數檔案則要傳播出去給需求者(CSR 給憑證中心簽署，CRT 給要使用 SSL 的 Server 使用)
ROOTCA_PUBLIC_PEQ_CSR=${ROOTCA_PRIVATE_DIR}/${ROOTCA_NAME}.req.pem.csr
ROOTCA_PUBLIC_CERT_DIR=${ROOTCA_DIR}/certs
ROOTCA_PUBLIC_CERT_CRT=${ROOTCA_PRIVATE_DIR}/${ROOTCA_NAME}.pem.crt

# 該變數是給 `ex.gen_rootca_cert_quick.sh` 所使用的
ROOTCA_QUICK_DIR=${HOME}/ownca
ROOTCA_QUICK_KEY=${ROOTCA_QUICK_DIR}/${ROOTCA_NAME}.key
ROOTCA_QUICK_CERT=${ROOTCA_QUICK_DIR}/${ROOTCA_NAME}.crt

