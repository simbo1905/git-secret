#!/bin/bash

# alias will need a shellopt command...
#alias git=hub

#need ssh key credentials to push to repo! 

if [ -z "$VERSION" ]; then
    (>&2 echo "ERROR please provide VERSION")
    exit 1
fi

if [ -z "$REPO" ]; then
    (>&2 echo "ERROR please provide REPO")
    exit 1
fi

TEMPLATE=$(realpath $(find . -type f -name git-secret.rb.template))

pushd $(brew --repository homebrew/core)

git checkout -b "$VERSION"

REPLACE=$(find Formula -type f -name git-secret.rb)

ARCHIVE="https://github.com/sobolevn/git-secret/archive/${VERSION}.tar.gz"

SHA256=$(wget -q -O - $ARCHIVE | shasum -a 256 | awk '{print $1}')

shaStart='s/^  sha256 .*/  sha256 "'
shaEnd='"/1'

urlStart='s/^\(  url "https:..github.com.sobolevn.git-secret.archive.\).*.tar.gz"/\1'
urlEnd='.tar.gz"/1'

cat $TEMPLATE | sed "$shaStart$SHA256$shaEnd" | sed "$urlStart$VERSION$urlEnd" > $REPLACE

#brew tests
brew install --build-from-source git-secret
brew test git-secret --devel
brew audit --strict git-secret

git add $REPLACE
git commit -m "git-secret $VERSION"
git push git@github.com:$REPO/homebrew-core.git "$VERSION"

popd