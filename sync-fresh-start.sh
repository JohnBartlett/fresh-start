#!/usr/bin/env bash
# sync-fresh-start.sh
# -------------------
# Sync local changes to GitHub:
#   1. add .gitignore entry for node_modules
#   2. stage & commit everything
#   3. pull --rebase from origin/master
#   4. push to origin/master
# Pass args:  [path-to-repo]  [commit message]

set -euo pipefail

# --- config -------------------------------------------------------------
REPO_DIR=${1:-$PWD}                   # default: current dir
COMMIT_MSG=${2:-"WIP local changes"} # default msg if none supplied
BRANCH="master"                       # change to 'main' if you renamed
# -----------------------------------------------------------------------

echo "🔎 Repo: $REPO_DIR  |  Branch: $BRANCH"

cd "$REPO_DIR" || { echo "❌ Repo path not found"; exit 1; }
git rev-parse --is-inside-work-tree >/dev/null \
  || { echo "❌ Not a git repository"; exit 1; }

# 1️⃣  Ensure node_modules is ignored
if ! grep -qxF 'node_modules/' .gitignore 2>/dev/null; then
  echo 'node_modules/' >> .gitignore
  echo "➕ Added node_modules/ to .gitignore"
fi

# 2️⃣  Stage everything (respecting .gitignore)
git add -A

# 3️⃣  Commit if there’s anything staged
if ! git diff --cached --quiet; then
  git commit -m "$COMMIT_MSG"
  echo "✅ Committed: $COMMIT_MSG"
else
  echo "ℹ️  No changes to commit"
fi

# 4️⃣  Pull with rebase to avoid merge commits
echo "🔄 Pulling + rebasing onto origin/$BRANCH ..."
if ! git pull --rebase origin "$BRANCH"; then
  echo "⚠️  Rebase stopped due to conflicts."
  echo "   • Resolve files marked <<<<<< / ====== / >>>>>>"
  echo "   • git add <fixed-file>"
  echo "   • git rebase --continue"
  echo "   • When rebase finishes: git push"
  exit 1
fi

# 5️⃣  Push local branch to origin
git push -u origin "$BRANCH"
echo "🚀 Pushed to origin/$BRANCH"

echo "🎉 Done. Local and remote are now in sync."
