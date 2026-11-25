#!/usr/bin/env bash
# Copy skills/ into Cursor, Codex, and Claude skill directories.
#   agents  .agents/skills   Cursor and Codex
#   claude  .claude/skills   Claude Code
#   cursor  .cursor/skills   Cursor only
#   codex   .codex/skills    older Codex location
set -euo pipefail

SCOPE="user"
ROOT=""
INTO="agents,claude"

usage() {
  cat <<'EOF'
Usage: install.sh [--scope user|project] [--root PATH] [--into agents,claude,cursor,codex]

  agents  .agents/skills   shared path read by Cursor and Codex
  claude  .claude/skills   Claude Code
  cursor  .cursor/skills   Cursor only
  codex   .codex/skills    older Codex location
EOF
}

rel_for() {
  case "$1" in
    agents) printf '%s\n' ".agents/skills" ;;
    claude) printf '%s\n' ".claude/skills" ;;
    cursor) printf '%s\n' ".cursor/skills" ;;
    codex) printf '%s\n' ".codex/skills" ;;
    *) return 1 ;;
  esac
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --scope)
      SCOPE="$2"
      shift 2
      ;;
    --root)
      ROOT="$2"
      shift 2
      ;;
    --into)
      INTO="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

case "$SCOPE" in
  user|project) ;;
  *)
    echo "Scope must be user or project" >&2
    exit 2
    ;;
esac

SOURCE="$(cd "$(dirname "$0")/.." && pwd)/skills"
if [[ ! -d "$SOURCE" ]]; then
  echo "Skills directory not found: $SOURCE" >&2
  exit 1
fi

if [[ -z "$ROOT" ]]; then
  if [[ "$SCOPE" == "user" ]]; then
    ROOT="$HOME"
  else
    ROOT="$(pwd)"
  fi
fi

if [[ ! -d "$ROOT" ]]; then
  echo "Root directory not found: $ROOT" >&2
  exit 1
fi
ROOT="$(cd "$ROOT" && pwd)"

IFS=',' read -r -a PARTS <<< "$INTO"
if [[ ${#PARTS[@]} -eq 0 ]]; then
  echo "Pass --into with one or more of: agents, claude, cursor, codex" >&2
  exit 2
fi

for part in "${PARTS[@]}"; do
  key="${part// /}"
  if ! rel="$(rel_for "$key")"; then
    echo "Unknown destination: $key" >&2
    exit 2
  fi
  dest="$ROOT/$rel"
  mkdir -p "$dest"
  for skill in "$SOURCE"/*; do
    [[ -d "$skill" ]] || continue
    name="$(basename "$skill")"
    rm -rf "$dest/$name"
    cp -a "$skill" "$dest/$name"
  done
  echo "Installed to $dest"
done
