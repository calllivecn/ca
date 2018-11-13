#!/bin/bash
# date 2018-11-12 21:58:57
# author calllivecn <c-all@qq.com>


set -xe

if [ "$1"x == "clear"x ];then
	rm -v *.crt *.csr *.key *.srl *.pem *.der
fi



CONFIG="-extfile myopenssl.cnf"


country_name="cn"
state_name="hubei"
locality_name="wuhan"

CN_root="zx root CA"
OU_root="zx OU"
O_root="zx O"


make_root_ca(){

# 1. 生成私钥root.key
openssl genrsa -out root.key 2048

# 2. 生成ca 证书请求
#openssl req -new -key root.key -subj "/CN=${CN_root}/OU=${OU_root}/O=${O_root}" -out root.csr
openssl req -new -key root.key -subj "/CN=${CN_root}/OU=${OU_root}/O=${O_root}" -out root.csr

# 3. 签名ca root证书
#openssl x509 -req -extensions v3_req -signkey root.key -in root.csr -out root.crt -days 3650
openssl x509 -req $CONFIG -extensions v3_ca -signkey root.key -in root.csr -out root.crt -days 3650

}
#make_root_ca


CN="zx ca CA"
OU="zx ca OU"
O="zx ca O"

make_ca_crt(){

# 1. 生成ca.key
openssl genrsa -out ca.key 2048

# 2. 生成请求csr
openssl req -new -key ca.key -subj "/CN=${CN}/OU=${OU}/O=${O}" -out ca.csr

openssl x509 -req -extensions v3_req -days 365 -signkey ca.key -in ca.csr -out ca.crt

}
#make_ca_crt

CN="nginx.cc"
OU="zx nginx test OU"
O="zx nginx test O"

make_server_crt(){

# 1. 生成server.key
openssl genrsa -out server.key 2048

# 2. 生成签名请求 server.csr
openssl req -new -key server.key -subj "/CN=${CN}/OU=${OU}/O=${O}" -out server.csr


# 3. 使用ca.crt ca.key为请求签名
openssl x509 -req $CONFIG -extensions v3_req -CA ca.crt -CAkey ca.key -CAcreateserial -days 3650 -in server.csr -out server.crt

}
make_server_crt


