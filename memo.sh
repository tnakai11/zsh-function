###############################################################################
# memo.sh ─ Quick daily-note helpers
#
# Provides five convenience commands once sourced:
#   memo        → open ~/memo/YYYY-MM-DD.txt (or YYYY-MM-DD_<slug>.txt) in $EDITOR
#   ml          → open the ~/memo directory itself in $EDITOR
#   mg PATTERN  → search every file in ~/memo with ripgrep (rg)
#   mr [N]      → show the first few lines from the N most recent notes (default: 7)
#   mf          → fuzzy-pick an existing note with fzf
#
# Customisation:
#   • Set MEMO_DIR before sourcing to change the note location.
#   • Set EDITOR (e.g., export EDITOR=nvim) to use a different editor.
###############################################################################

# Directory that stores your notes (override if you like)
MEMO_DIR="${MEMO_DIR:-$HOME/memo}"

# Helper: open a file or directory in the chosen editor
_memo_open() {
  "${EDITOR:-vim}" "$@"
}

###############################################################################
# memo ─ open today’s note (or a suffixed note) in the editor
###############################################################################
memo() {
  mkdir -p "$MEMO_DIR"                 # ensure the target directory exists
  local ymd
  ymd="$(date +%Y-%m-%d)"              # today’s date, YYYY-MM-DD

  if [ "$#" -eq 0 ]; then
    _memo_open "$MEMO_DIR/${ymd}.txt"
  else
    # join all arguments with underscores to form a slug
    local slug
    slug="$(printf '%s' "$*" | tr ' ' '_')"
    _memo_open "$MEMO_DIR/${ymd}_${slug}.txt"
  fi
}

###############################################################################
# ml ─ open the memo directory itself in the editor
###############################################################################
ml() {
  _memo_open "$MEMO_DIR"
}

###############################################################################
# mg ─ search memo files with ripgrep
###############################################################################
mg() {
  if ! command -v rg >/dev/null 2>&1; then
    printf 'mg: ripgrep (rg) is not installed or not in PATH\n' >&2
    return 1
  fi
  rg "$@" "$MEMO_DIR"
}

###############################################################################
# mr ─ show lines from the N most recently modified memo files
###############################################################################
mr() {
  local n="${1:-7}"
  ls -1t "$MEMO_DIR" | head -n "$n" | while IFS= read -r f; do
    printf '==> %s <==\n' "$f"
    head -n 5 "$MEMO_DIR/$f"
    echo
  done
}

###############################################################################
# mf ─ fuzzy-pick a memo file to open with fzf
###############################################################################
mf() {
  if ! command -v fzf >/dev/null 2>&1; then
    printf 'mf: fzf is not installed or not in PATH\n' >&2
    return 1
  fi

  local file
  file=$(ls -1 "$MEMO_DIR"/*.txt 2>/dev/null | fzf) || return
  [ -n "$file" ] && _memo_open "$file"
}

