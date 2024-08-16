#!/usr/bin/env bash
set -euo pipefail

. .env

cat in/export-board*.json | jq > in/wekan.json

# cat in/export-board*.json | jq -r '.cards[]._id'
# cat in/export-board*.json | jq -r '.comments[] | [.cardId, .createdAt, .text]'

cat in/export-board*.json | jq -r '. as $root | .comments[] | . as $comment | [($root.cards[] | select(._id == $comment.cardId).title), .createdAt, .text] | @tsv' > out/wekan.tsv

# https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4
# https://jqplay.org/

cat "out/wekan.tsv" | tr '\t' '\a' | while IFS=$'\a' read -r card_title datetime text other
do
  test -z "$other" || (echo error && exit)
  year=$(date +%Y -d "$card_title")
  month=$(date +%m -d "$card_title")
  file=$year/$month/$card_title-wekan.md
  datetime2=$(date "+%F %T %z" -d $datetime)

  mkdir -p $year/$month
  echo -e "## $datetime2\n\n$text\n" >> "$file"

  echo $file $datetime2
done
