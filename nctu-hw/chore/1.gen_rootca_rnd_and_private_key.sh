#!/bin/bash
INCLUDE_VARS="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )/vars.sh"
source $INCLUDE_VARS

# 建立 rootca private 資料夾
mkdir -p ${ROOTCA_PRIVATE_DIR}

# 建立亂數種子檔給 rootca 的私鑰用
openssl rand -out ${ROOTCA_PRIVATE_KEY} 4096
chmod og-rwx ${ROOTCA_PRIVATE_KEY}

# # 使用亂數種子建立 rootca 的私鑰
# openssl genrsa -aes256 -rand ${ROOTCA_PRIVATE_RND} -out ${ROOTCA_PRIVATE_KEY} 4096
# chmod og-rwx ${ROOTCA_PRIVATE_KEY}

# 不使用亂數種子建立 rootca 的私鑰(mac osx沒有 rand 參數)
openssl genrsa -aes256 -out ${ROOTCA_PRIVATE_KEY} 4096
chmod og-rwx ${ROOTCA_PRIVATE_KEY}
