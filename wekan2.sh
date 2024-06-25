#!/usr/bin/env bash
set -euo pipefail

. .env

cat in/export-board*.json | jq > in/wekan.json

# cat in/export-board*.json | jq -r '.cards[]._id'
# cat in/export-board*.json | jq -r '.comments[] | [.cardId, .createdAt, .text]'

cat in/export-board*.json | jq -r '. as $root | .comments[] | . as $comment | [($root.cards[] | select(._id == $comment.cardId).title), .createdAt, .text]'

# https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4
# https://jqplay.org/

