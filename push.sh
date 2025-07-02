#!/usr/bin/env bash
# push.sh  —  stage > commit > rebase-pull > push
set -euo pipefail

BRANCH="master"                              # change to 'main' if needed
MSG="${1:-"WIP commit $(date +%F_%T)"}"      # message arg or timestamp fallback

# 1. make sure node_modules isn't tracked
grep -qxF 'node_modules/' .gitignore 2>/dev/null || echo 'node_modules/' >> .gitignore

# 2. stage and commit everything
git add -A
if git diff --cached --quiet; then
  echo "ℹ️  Nothing to commit."
else
  git commit -m "$MSG"
  echo "✅  Committed: $MSG"
fi

# 3. rebase onto latest remote work (fast-forward friendly)
git pull --rebase origin "$BRANCH"

# 4. push
git push -u origin "$BRANCH"
echo "🚀  Pushed to origin/$BRANCH"
