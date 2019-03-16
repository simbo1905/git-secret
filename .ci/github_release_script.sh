#!/bin/bash

# https://github.com/travis-ci/dpl/issues/155
# https://gist.github.com/Jaskaranbir/d5b065173b3a6f164e47a542472168c1

LAST_RELEASE_TAG=$(curl https://api.github.com/repos/$TRAVIS_REPO_SLUG/releases/latest 2>/dev/null | jq .name | sed 's/"//g')

echo "LAST_RELEASE_TAG=$LAST_RELEASE_TAG"

# An automatic changelog generator
gem install github_changelog_generator

# if we dont remove the manual changlog from the local checkout it is 
# uploaded. we might in the future rename it HISTORY.md and it will be 
# automatically appended to. here we just remove if from the local checkout
# since it is already tagged and in the release. 
#rm CHANGELOG.md

# Generate CHANGELOG.md
github_changelog_generator \
  -u $(cut -d "/" -f1 <<< $TRAVIS_REPO_SLUG) \
  -p $(cut -d "/" -f2 <<< $TRAVIS_REPO_SLUG) \
  --token $GITHUB_OAUTH_TOKEN \
  --output generate.md \
  --since-tag ${LAST_RELEASE_TAG}

body="$(cat generate.md)"

# GitHub API needs json data. here we use the mighty jq from https://stedolan.github.io/jq/
jq -n \
  --arg body "$body" \
  --arg name "$TRAVIS_TAG" \
  --arg tag_name "$TRAVIS_TAG" \
  --arg target_commitish "$GIT_BRANCH" \
  '{
    body: $body,
    name: $name,
    tag_name: $tag_name,
    target_commitish: $target_commitish,
    draft: true,
    prerelease: false
  }' > generate.md
  
echo "Create release $TRAVIS_TAG for repo: $TRAVIS_REPO_SLUG, branch: $GIT_BRANCH"
curl -H "Authorization: token $GITHUB_OAUTH_TOKEN" --data @generate.md "https://api.github.com/repos/$TRAVIS_REPO_SLUG/releases"
