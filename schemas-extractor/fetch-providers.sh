#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

pushd "$(dirname "$0")" >/dev/null

get_org_repos() {
  echo "Fetching repositories from organization $1..."
  local idx=1
  while curl -u maxbog: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 -s "https://api.github.com/orgs/$1/repos?sort=full_name&per_page=100&page=${idx}" | jq -re '.[].name' >>"$2"; do
    echo "Fetched page $idx"
    idx=$((idx + 1))
  done
  echo "Done"
}


get_user_repos() {
  echo "Fetching repositories from user $1..."
  local idx=1
  while curl -u maxbog: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 -s "https://api.github.com/users/$1/repos?sort=full_name&per_page=100&page=${idx}" | jq -re '.[].name' >>"$2"; do
    echo "Fetched page $idx"
    idx=$((idx + 1))
  done
  echo "Done"
}

rm -f repositories.list.full
get_org_repos "terraform-providers" repositories.list.full
get_org_repos "hashicorp" repositories.list.full
get_user_repos "Mongey" repositories.list.full
echo "Filtering terrform providers repos..."
grep -- '^terraform-provider-' repositories.list.full | awk '{print substr($0, 20)}' | sort >providers.list

echo "Done"
popd >/dev/null
