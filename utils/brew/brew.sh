#!/bin/bash

# alias will need a shellopt command...
#alias git=hub

#need ssh key credentials to push to repo! 

if [ -z "$VERSION" ]; then
    (>&2 echo "ERROR please provide VERSION")
    exit 1
fi

git clone git@github.com:simbo1905/homebrew-core.git
pushd homebrew-core
git checkout -b "$VERSION" 
REPLACE=$(find Formula -type f -name git-secret.rb)

echo "REPLACE=$REPLACE"

ARCHIVE="https://github.com/sobolevn/git-secret/archive/${VERSION}.tar.gz"

SHA256=$(wget -q -O - $ARCHIVE | shasum -a 256 | awk '{print $1}')

a='s/^  sha256 .*/  sha256 "'
b='"/1'

cat ../git-secret.rb | sed "$a$SHA256$b" > $REPLACE
git add $REPLACE
git commit -m "update git-secret to version $VERSION"
git push origin "$VERSION" 
popd