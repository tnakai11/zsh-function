# zsh-function

Personal helper scripts for Zsh. The main script, `memo.sh`, provides handy commands for managing daily notes.

## memo.sh

1. **memo [slug]**  – open today's note in `$EDITOR`. If you pass words, they become a suffix like `YYYYMMDD_slug.txt`.
2. **ml** – open the memo directory in `$EDITOR`.
3. **mg PATTERN** – search notes with `ripgrep`.
4. **mr [N]** – show the first few lines from the N most recent notes (default: 7).
5. **mf** – fuzzy‑search notes by name or contents via `fzf` (requires `ripgrep`; previews with `bat` if available).

Set `MEMO_DIR` before sourcing to change the directory. Define `EDITOR` (e.g., `export EDITOR=nvim`) to use a different editor.

