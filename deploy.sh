#!/usr/bin/env bash
set -euo pipefail

# Build static site
cd "$(dirname "$0")"
bun run build

# Deploy to vp03 nginx
rsync -avz --delete dist/ vp03:/var/www/html/onboard/

# Reload nginx config
ssh vp03 "sudo nginx -t && sudo nginx -s reload"

echo "Deployed to https://bmblx.bmi.osumc.edu/onboard/"
