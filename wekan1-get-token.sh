#!/usr/bin/env bash
set -euo pipefail

. .env

token=$(curl -k "$wekan_server_url/users/login" \
  -u "$wekan_server_user:$wekan_server_password" \
  -d "email=$wekan_login&password=$wekan_pass" \
  | jq -r '.token')

echo "$token"
echo "wekan_token=$token" >> .env
