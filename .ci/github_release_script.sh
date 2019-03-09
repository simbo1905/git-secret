#!/bin/bash

# https://github.com/travis-ci/dpl/issues/155
# https://gist.github.com/Jaskaranbir/d5b065173b3a6f164e47a542472168c1

set -euxo pipefail

# ===> Set these variables first
branch="$GIT_BRANCH"
# Example: "Jaskaranbir/MyRepo"
repo_slug="$TRAVIS_REPO_SLUG"
token="$GITHUB_OAUTH_TOKEN"
version="$TRAVIS_TAG"

# An automatic changelog generator
gem install github_changelog_generator

LAST_RELEASE_TAG=$(curl https://api.github.com/repos/$repo_slug/releases/latest 2>/dev/null | jq .name | sed 's/"//g')

# Generate CHANGELOG.md
github_changelog_generator \
  -u $(cut -d "/" -f1 <<< $repo_slug) \
  -p $(cut -d "/" -f2 <<< $repo_slug) \
  --token $token \
  --since-tag ${LAST_RELEASE_TAG}

body="$(cat CHANGELOG.md)"

# Overwrite CHANGELOG.md with JSON data for GitHub API
jq -n \
  --arg body "$body" \
  --arg name "$version" \
  --arg tag_name "$version" \
  --arg target_commitish "$branch" \
  '{
    body: $body,
    name: $name,
    tag_name: $tag_name,
    target_commitish: $target_commitish,
    draft: true,
    prerelease: false
  }' > CHANGELOG.md

echo "Create release $version for repo: $repo_slug, branch: $branch"
curl -H "Authorization: token $token" --data @CHANGELOG.md "https://api.github.com/repos/$repo_slug/releases"