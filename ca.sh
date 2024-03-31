#!/bin/bash
# date 2018-11-12 21:58:57
# author calllivecn <calllivecn@outlook.com>


set -xe

if [ "$1"x == "clear"x ];then
	rm -v *.crt *.csr *.key *.srl *.pem *.der
fi



#CONFIG="-extfile MyCA.cnf"


country_name="cn"
state_name="hubei"
locality_name="wuhan"

CN_ca="zx root CA"
OU_ca="zx OU"
O_ca="zx O"


make_ca(){

# 1. 生成私钥root.key
openssl genrsa -out ca.key 2048

# 2. 生成ca 证书请求
#openssl req -new -key ca.key -subj "/CN=${CN_ca}/OU=${OU_ca}/O=${O_ca}" -out ca.csr
openssl req -new -key ca.key -subj "/CN=${CN_ca}/OU=${OU_ca}/O=${O_ca}" -out ca.csr

# 3. 签名ca root证书
#openssl x509 -req -extensions v3_req -signkey ca.key -in ca.csr -out ca.crt -days 3650
openssl x509 -req $CONFIG -extensions v3_ca -signkey ca.key -in ca.csr -out ca.crt -days 3650

}
#make_ca

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
#make_server_crt


selfsign(){

#openssl genrsa selfsign.key 2048
openssl genrsa -out selfsign.key 2048
openssl req -new -x509 -days 365 -key selfsign.key -out selfsign.crt

}
selfsign
