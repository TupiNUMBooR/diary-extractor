#!/usr/bin/env bash
set -euo pipefail

. .env

api_url="https://api.trello.com/1"
keys="key=$trello_api_key&token=$trello_token"

# comments=$(curl "$api_url/boards/$board?$keys&actions=commentCard&page=1")
# echo "$comments" | jq -r '.actions[] | [.data.card.name, .date, .data.dateLastEdited, .data.text] | @tsv'
i=0
rm -f 1.tsv
while true; do
  comments=$(curl "$api_url/boards/$board/actions?$keys&filter=commentCard&page=$i")
  [[ -z "$comments" || $i > 100 ]] && break
  echo "$comments" | jq -r '.[] | [.data.card.name, .date, .data.dateLastEdited, .data.text] | @tsv' >> 1.tsv
  echo page $i ok
  i=$((i+1))
done
