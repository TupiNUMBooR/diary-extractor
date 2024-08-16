#!/usr/bin/env bash
set -euo pipefail

dir=${1:-out}
cd "$dir"

for f in *.md; do
  echo "$f";
  year=$(echo $f | awk -F'-' '{print $1}')
  month=$(echo $f | awk -F'-' '{print $2}')
  folder="sorted/$year/$month"
  mkdir -p "$folder"
  cp "$f" "$folder"
done

