#!/usr/bin/env bash
# dev.sh — run local server with live-reload
set -euo pipefail

echo "💻  Starting nodemon on port 5500 …  (Ctrl-C to stop)"
npm run dev
