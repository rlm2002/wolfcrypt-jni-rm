
# Example KeyStore Update Script
#
# This script is Used to update all example JKS and WKS stores, using example
# certificates found in wolfSSL proper.
#
# Java KeyStores which this script creates includes the following. WKS
# versions will also be generated of each of these:
#
# client.jks              RSA 2048-bit and ECC client certs:
#                         client-cert.pem, client-ecc-cert.pem
# client-rsa-1024.jks     RSA 1024-bit only client cert:
#                         1024/client-cert.pem, 1024/client-key.pem
# client-rsa.jks          RSA 2048-bit only client cert:
#                         client-cert.pem, client-key.pem
# client-ecc.jks          ECC only client cert:
#                         client-ecc-cert.pem, ecc-client-key.pem
# server.jks              RSA 2048-bit and ECC server certs:
#                         server-cert.pem, server-ecc.pem
# server-rsa-1024.jks     RSA 1024-bit only server cert:
#                         1024/server-cert.pem, 1024/server-key.pem
# server-rsa.jks          RSA 2048-bit only server cert:
#                         server-cert.pem, server-key.pem
# server-ecc.jks          ECC only server cert:
#                         server-ecc.pem, ecc-key.pem
# cacerts.jks             All CA certs (RSA, ECC, 1024, 2048, etc)
# ca-client.jks           CA certs used to verify client certs:
#                         client-cert.pem, client-ecc-cert.pem
# ca-server.jks           CA certs used to verify server certs:
#                         ca-cert.pem, ca-ecc-cert.pem
# ca-server-rsa-2048.jks  CA cert used to verify 2048-bit RSA server cert:
#                         ca-cert.pem
# ca-server-ecc-256.jks   CA cert used to veirfy ECC P-256 server cert:
#                         ca-ecc-cert.pem
#
# NOTE: Keystores generated by this script are generated in JKS format,
#       instead of the newer/better PKCS#12 format. The newer format would
#       be preferred, but older versions of keytool do not support PKCS#12
#       format. This would cause test failures in those older environments.

printf "Removing and updating example JKS and WKS KeyStore files\n"
if [ -z "$1" ]; then
    printf "\tNo directory to certs provided\n"
    printf "\tExample use ./update-jks-wks.sh ~/wolfssl/certs\n"
    exit 1;
fi
CERT_LOCATION=$1

# Export library paths for Linux and Mac to find shared JNI library
export LD_LIBRARY_PATH=../../lib:$LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=../../lib:$DYLD_LIBRARY_PATH

# ARGS: <keystore-name> <cert file> <alias> <password>
add_cert() {
    keytool -import -keystore "$1" -file "$CERT_LOCATION/$2" -alias "$3" -noprompt -trustcacerts -deststoretype JKS -storepass "$4" &> /dev/null
    if [ $? -ne 0 ]; then
        printf "fail"
        exit 1
    fi
}

# ARGS: <keystore-name> <cert file> <key file> <alias> <password>
add_cert_key() {
    openssl pkcs12 -export -in "$CERT_LOCATION/$2" -inkey "$CERT_LOCATION/$3" -out tmp.p12 -passin pass:"$5" -passout pass:"$5" -name "$4" &> /dev/null
    keytool -importkeystore -deststorepass "$5" -destkeystore "$1" -deststoretype JKS -srckeystore tmp.p12 -srcstoretype PKCS12 -srcstorepass "$5" -alias "$4" &> /dev/null
    if [ $? -ne 0 ]; then
        printf "fail"
        exit 1
    fi
    rm tmp.p12
}

# ARGS: <keystore-name> <password>
jks_to_wks() {
    keytool -importkeystore -srckeystore ${1}.jks -destkeystore ${1}.wks -srcstoretype JKS -deststoretype WKS -srcstorepass "$2" -deststorepass "$2" -provider com.wolfssl.provider.jce.WolfCryptProvider --providerpath ../../lib/wolfcrypt-jni.jar &> /dev/null
    if [ $? -ne 0 ]; then
        printf "fail"
        exit 1
    fi

}

#################### CLIENT KEYSTORES ####################

# Client cert: both RSA 2048-bit and ECC
printf "\tCreating client.jks ..."
rm client.jks &> /dev/null
add_cert_key "client.jks" "/client-cert.pem" "/client-key.pem" "client" "wolfsslpassword"
add_cert_key "client.jks" "/client-ecc-cert.pem" "/ecc-client-key.pem" "client-ecc" "wolfsslpassword"
printf "done\n"

# Client cert: RSA, 1024-bit only
printf "\tCreating client-rsa-1024.jks ..."
rm client-rsa-1024.jks &> /dev/null
add_cert_key "client-rsa-1024.jks" "/1024/client-cert.pem" "/1024/client-key.pem" "client-rsa-1024" "wolfsslpassword"
printf "done\n"

# Client cert: RSA 2048-bit only
printf "\tCreating client-rsa.jks ..."
rm client-rsa.jks &> /dev/null
add_cert_key "client-rsa.jks" "/client-cert.pem" "/client-key.pem" "client-rsa" "wolfsslpassword"
printf "done\n"

# Client cert: ECC only
printf "\tCreating client-ecc.jks ..."
rm client-ecc.jks &> /dev/null
add_cert_key "client-ecc.jks" "/client-ecc-cert.pem" "/ecc-client-key.pem" "client-ecc" "wolfsslpassword"
printf "done\n"

#################### SERVER KEYSTORES ####################

# Server cert: both RSA 2048-bit and ECC
printf "\tCreating server.jks ..."
rm server.jks &> /dev/null
add_cert_key "server.jks" "/server-cert.pem" "/server-key.pem" "server" "wolfsslpassword"
add_cert_key "server.jks" "/server-ecc.pem" "/ecc-key.pem" "server-ecc" "wolfsslpassword"
printf "done\n"

# Server cert: RSA, 1024-bit only
printf "\tCreating server-rsa-1024.jks ..."
rm server-rsa-1024.jks &> /dev/null
add_cert_key "server-rsa-1024.jks" "/1024/server-cert.pem" "/1024/server-key.pem" "server-1024" "wolfsslpassword"
printf "done\n"

# Server cert: RSA, 2048-bit only
printf "\tCreating server-rsa.jks ..."
rm server-rsa.jks &> /dev/null
add_cert_key "server-rsa.jks" "/server-cert.pem" "/server-key.pem" "server-rsa" "wolfsslpassword"
printf "done\n"

# Server cert: ECC only
printf "\tCreating server-ecc.jks ..."
rm server-ecc.jks &> /dev/null
add_cert_key "server-ecc.jks" "/server-ecc.pem" "/ecc-key.pem" "server-ecc" "wolfsslpassword"
printf "done\n"

#################### CA CERT KEYSTORES ###################

# Contains all CA certs (RSA and ECC), verifies both client and server certs
printf "\tCreating cacerts.jks ..."
rm cacerts.jks &> /dev/null
add_cert_key "cacerts.jks" "/ca-cert.pem" "/ca-key.pem" "cacert" "wolfsslpassword"
add_cert_key "cacerts.jks" "/client-cert.pem" "/client-key.pem" "client-rsa" "wolfsslpassword"
add_cert_key "cacerts.jks" "/client-ecc-cert.pem" "/ecc-client-key.pem" "client-ecc" "wolfsslpassword"
add_cert_key "cacerts.jks" "/ca-cert.pem" "/ca-key.pem" "ca-rsa" "wolfsslpassword"
add_cert_key "cacerts.jks" "/ca-ecc-cert.pem" "/ca-ecc-key.pem" "ca-ecc" "wolfsslpassword"
add_cert_key "cacerts.jks" "/1024/ca-cert.pem" "/1024/ca-key.pem" "ca-1024" "wolfsslpassword"
printf "done\n"

# Contains CA certs used to verify client certs:
# client-cert.pem verifies itself (self signed)
# client-ecc-cert.pem verifies itself (self signed)
printf "\tCreating ca-client.jks ..."
rm ca-client.jks &> /dev/null
add_cert_key "ca-client.jks" "/client-cert.pem" "/client-key.pem" "client-rsa" "wolfsslpassword"
add_cert_key "ca-client.jks" "/client-ecc-cert.pem" "/ecc-client-key.pem" "client-ecc" "wolfsslpassword"
printf "done\n"

# Contains CA certs used to verify server certs:
# ca-cert.pem verifies server-cert.pem
# ca-ecc-cert.pem verifies server-ecc.pem
printf "\tCreating ca-server.jks ..."
rm ca-server.jks &> /dev/null
add_cert_key "ca-server.jks" "/ca-cert.pem" "/ca-key.pem" "ca-rsa" "wolfsslpassword"
add_cert_key "ca-server.jks" "/ca-ecc-cert.pem" "/ca-ecc-key.pem" "ca-ecc" "wolfsslpassword"
printf "done\n"

# Contains CA cert used to verify RSA 2048-bit server cert:
# ca-cert.pem verifies server-cert.pem
printf "\tCreating ca-server-rsa-2048.jks ..."
rm ca-server-rsa-2048.jks &> /dev/null
#add_cert_key "ca-server-rsa-2048.jks" "/ca-cert.pem" "/ca-key.pem" "ca-rsa" "wolfsslpassword"
add_cert "ca-server-rsa-2048.jks" "/ca-cert.pem" "ca-rsa" "wolfsslpassword"
printf "done\n"

# Contains CA cert used to verify ECC P-256 server cert:
# ca-ecc-cert.pem verifies server-ecc.pem
printf "\tCreating ca-server-ecc-256.jks ..."
rm ca-server-ecc-256.jks &> /dev/null
#add_cert_key "ca-server-ecc-256.jks" "/ca-ecc-cert.pem" "/ca-ecc-key.pem" "ca-ecc" "wolfsslpassword"
add_cert "ca-server-ecc-256.jks" "/ca-ecc-cert.pem" "ca-ecc" "wolfsslpassword"
printf "done\n"

################### CONVERT JKS TO WKS ###################

printf "\nConverting keystores from JKS to WKS ...\n"

printf "\tCreating client.wks ..."
rm client.wks &> /dev/null
jks_to_wks "client" "wolfsslpassword"
printf "done\n"

printf "\tCreating client-rsa-1024.wks ..."
rm client-rsa-1024.wks &> /dev/null
jks_to_wks "client-rsa-1024" "wolfsslpassword"
printf "done\n"

printf "\tCreating client-rsa.wks ..."
rm client-rsa.wks &> /dev/null
jks_to_wks "client-rsa" "wolfsslpassword"
printf "done\n"

printf "\tCreating client-ecc.wks ..."
rm client-ecc.wks &> /dev/null
jks_to_wks "client-ecc" "wolfsslpassword"
printf "done\n"

printf "\tCreating server.wks ..."
rm server.wks &> /dev/null
jks_to_wks "server" "wolfsslpassword"
printf "done\n"

printf "\tCreating server-rsa-1024.wks ..."
rm server-rsa-1024.wks &> /dev/null
jks_to_wks "server-rsa-1024" "wolfsslpassword"
printf "done\n"

printf "\tCreating server-rsa.wks ..."
rm server-rsa.wks &> /dev/null
jks_to_wks "server-rsa" "wolfsslpassword"
printf "done\n"

printf "\tCreating server-ecc.wks ..."
rm server-ecc.wks &> /dev/null
jks_to_wks "server-ecc" "wolfsslpassword"
printf "done\n"

printf "\tCreating cacerts.wks ..."
rm cacerts.wks &> /dev/null
jks_to_wks "cacerts" "wolfsslpassword"
printf "done\n"

printf "\tCreating ca-client.wks ..."
rm ca-client.wks &> /dev/null
jks_to_wks "ca-client" "wolfsslpassword"
printf "done\n"

printf "\tCreating ca-server.wks ..."
rm ca-server.wks &> /dev/null
jks_to_wks "ca-server" "wolfsslpassword"
printf "done\n"

printf "\tCreating ca-server-rsa-2048.wks ..."
rm ca-server-rsa-2048.wks &> /dev/null
jks_to_wks "ca-server-rsa-2048" "wolfsslpassword"
printf "done\n"

printf "\tCreating ca-server-ecc-256.wks ..."
rm ca-server-ecc-256.wks &> /dev/null
jks_to_wks "ca-server-ecc-256" "wolfsslpassword"
printf "done\n"
