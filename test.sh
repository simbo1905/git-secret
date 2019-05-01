#!/bin/bash
docker exec -it gpg1 apk add gnupg1 1>/dev/null
VERSION=$(docker exec -it gpg1 gpg --version | head -1)
cowsay "gpg1 is $VERSION"

docker exec -it gpg21 apk add gnupg 1>/dev/null
VERSION=$(docker exec -it gpg21 gpg --version | head -1)
cowsay "gpg12 is $VERSION"

docker exec -it gpg22 apk add gnupg  1>/dev/null
VERSION=$(docker exec -it gpg22 gpg --version | head -1)
cowsay "gpg22 is $VERSION"

function gpg14 {
  docker exec -it gpg1 "$@"
}

function gpg21 {
  docker exec -it gpg21 "$@"
}

function gpg22 {
  docker exec -it gpg22 "$@"
}

# some versions can resolve the key server other versions need the IP address
# https://github.com/rvm/rvm/issues/3544
KEY_SERVER_IP=$(ping -t 1 keys.gnupg.net | head -1 | sed 's/.* (\([^)]*\)).*/\1/g')

EMAIL=mpapis@gmail.com

# export a key from gpg14
mkdir -p ./shared/gpg1
gpg14 gpg --keyserver $KEY_SERVER_IP --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
gpg14 gpg --list-keys --with-colons --with-fingerprint --keyid-format long $EMAIL > ./shared/gpg1/$EMAIL
KID=$(awk -F: '$1~/pub/{print $5; exit}' ./shared/gpg1/$EMAIL)
gpg14 gpg --export -a $EMAIL > ./shared/gpg1/$KID.pub.key
mv ./shared/gpg1/$EMAIL ./shared/gpg1/$KID.pub.cln

# export a key from gpg21
mkdir -p ./shared/gpg21
gpg21 gpg --keyserver $KEY_SERVER_IP --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
gpg21 gpg --list-keys --with-colons --with-fingerprint --keyid-format long $EMAIL > ./shared/gpg21/$EMAIL
KID=$(awk -F: '$1~/pub/{print $5; exit}' ./shared/gpg21/$EMAIL)
gpg21 gpg --export -a $EMAIL > ./shared/gpg21/$KID.pub.key
mv ./shared/gpg21/$EMAIL ./shared/gpg21/$KID.pub.cln

# assert its the same export
if ! diff ./shared/gpg1/$KID.pub.key ./shared/gpg21/$KID.pub.key; then
  2>&1 echo "PANIC! gpg1 and gpg21 export differnt $KID.pub.key"
  exit 1
fi

# export a key from gpg212
mkdir -p ./shared/gpg22
gpg22 gpg --keyserver $KEY_SERVER_IP --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
gpg22 gpg --list-keys --with-colons --with-fingerprint --keyid-format long $EMAIL > ./shared/gpg22/$EMAIL
KID=$(awk -F: '$1~/pub/{print $5; exit}' ./shared/gpg22/$EMAIL)
gpg22 gpg --export -a $EMAIL > ./shared/gpg22/$KID.pub.key
mv ./shared/gpg22/$EMAIL ./shared/gpg22/$KID.pub.cln

# assert its the same export
if ! diff ./shared/gpg21/$KID.pub.key ./shared/gpg22/$KID.pub.key; then
  2>&1 echo "PANIC! gpg21 and gpg22 export differnt $KID.pub.key"
  exit 1
fi
