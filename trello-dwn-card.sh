#!/usr/bin/env bash
set -euo pipefail

. .env

api_url="https://api.trello.com/1"
keys="key=$trello_api_key&token=$trello_token"
card=$1
file_tsv="out/$card.tsv"

mkdir -p out

rm -rf "$file_tsv"
i=0
while true; do
  comments=$(curl -s "$api_url/cards/$card/actions?$keys&filter=commentCard&page=$i")
  [[ -z "$comments" || $i > 100 ]] && break
  echo "$comments" | jq -r '.[] | [.date, .data.card.name, .data.text] | @tsv' | sort >> "$file_tsv"

  echo page $i ok
  i=$((i+1))
done

IFS=$'\a' read -r datetime card_title text other < <(cat "$file_tsv" | tr '\t' '\a')
card_date=$(date +%F -d $datetime)
file_md="out/$card_date.md"
echo "$file_md $card_title"

echo -e "# $card_title\n" > "$file_md"

cat "$file_tsv" | tr '\t' '\a' | while IFS=$'\a' read -r datetime card_title text other
do
  test -z "$other" || (echo error && exit)
  date=$(date +%F -d $datetime)
  if [[ "$date" == "$card_date" ]]; then
    time=$(date +%T -d $datetime)
  else
    time=$datetime
  fi
  echo -e "## $time\n\n$text\n" >> "$file_md"
done
