#!/bin/bash

REPO_DIR="/srv/salt"

cd "$REPO_DIR" || exit 1

echo "==> Pulling latest changes..."
git pull

echo "==> Refreshing pillar..."
salt '*' saltutil.refresh_pillar

echo "==> Refreshing modules..."
salt '*' saltutil.sync_all

echo "==> Done."