#!/usr/bin/env bash
# Saves the solution on your clipboard into journey/katas and pushes it.
# Usage:  kata.sh <language> <kyu> <kata-slug>
# Example: kata.sh python 8 sum-of-positive
# (the slug is the last part of the kata's URL on Codewars)
set -euo pipefail

JOURNEY_DIR="${JOURNEY_DIR:-$HOME/journey}"   # where your journey repo is cloned

lang="${1:-}"; kyu="${2:-}"; slug="${3:-}"
if [[ -z "$lang" || -z "$kyu" || -z "$slug" ]]; then
  echo "Usage: kata.sh <language> <kyu> <kata-slug>"; exit 1
fi

case "$lang" in
  python)        ext=py;   c="#"  ;;
  java)          ext=java; c="//" ;;
  javascript|js) lang=javascript; ext=js; c="//" ;;
  go)            ext=go;   c="//" ;;
  *) echo "Unsupported language: $lang (python, java, javascript, go)"; exit 1 ;;
esac

if   command -v xclip    >/dev/null; then code=$(xclip -selection clipboard -o)
elif command -v wl-paste >/dev/null; then code=$(wl-paste)
else echo "Install xclip first: sudo apt install xclip"; exit 1; fi
[[ -n "${code// }" ]] || { echo "Clipboard is empty. Copy your solution first."; exit 1; }

dir="$JOURNEY_DIR/katas/$lang/${kyu}kyu"
file="$dir/$slug.$ext"
mkdir -p "$dir"
[[ ! -e "$file" ]] || { echo "Already saved: $file"; exit 1; }

{
  echo "$c Codewars kata: https://www.codewars.com/kata/$slug"
  echo "$c ${kyu} kyu, $lang"
  echo
  printf '%s\n' "$code"
} > "$file"

git -C "$JOURNEY_DIR" add "$file"
git -C "$JOURNEY_DIR" commit -m "kata: $slug (${kyu} kyu, $lang)"
git -C "$JOURNEY_DIR" push
echo "Saved and pushed: katas/$lang/${kyu}kyu/$slug.$ext"
