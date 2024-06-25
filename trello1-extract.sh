#!/usr/bin/env bash
set -euo pipefail

# cat trello1.tsv | sort
# | tr '.' '-' | read d; date -d $d;

rm -rf out
mkdir out
cat trello1.tsv | sort | tr '\t' '\a' | while IFS=$'\a' read -r date time edit_time text other
do
  test -z "$other" || (echo error && exit)
  newdate=$(echo "$date" | tr '.' '-' | date "+%F" -f -) || newdate=$(date +%F -d $time)
  echo $newdate
  time=$(date +%T -d $time)
  echo "# $time" >> "out/$newdate.md"
  echo -e "\n$text\n" >> "out/$newdate.md"
done
