#!/usr/bin/env bash
# Installs the asd-ste100 skill's three layers into a Claude Code setup:
#   1. the skill (runtime files only)      -> ~/.claude/skills/asd-ste100/
#   2. the always-on distilled rules block -> ~/.claude/rules/ste-writing-<lang>.md
#   3. the /ste re-anchor command          -> ~/.claude/commands/ste.md (ko-only: ste.md; both: en=ste.md, ko=ste-ko.md)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="${HOME}/.claude/skills"
RULES_DIR="${HOME}/.claude/rules"
COMMANDS_DIR="${HOME}/.claude/commands"
FORCE=0
DO_SKILL=1
DO_RULES=1
DO_COMMAND=1
LANGS=()

usage() {
  cat <<'EOF'
Usage: ./install.sh [en] [ko] [options]

Pick at least one language. Options:
  --skills-dir DIR    override the skills directory (default ~/.claude/skills)
  --rules-dir DIR     override the rules directory (default ~/.claude/rules)
  --commands-dir DIR  override the commands directory (default ~/.claude/commands)
  --no-skill          skip the skill layer
  --no-rules          skip the always-on rules layer
  --no-command        skip the /ste command layer
  --force             overwrite existing files
  -h, --help          show this help
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    en|ko) LANGS+=("$1") ;;
    --skills-dir) SKILLS_DIR="$2"; shift ;;
    --rules-dir) RULES_DIR="$2"; shift ;;
    --commands-dir) COMMANDS_DIR="$2"; shift ;;
    --no-skill) DO_SKILL=0 ;;
    --no-rules) DO_RULES=0 ;;
    --no-command) DO_COMMAND=0 ;;
    --force) FORCE=1 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

if [ ${#LANGS[@]} -eq 0 ]; then
  echo "Pick at least one language: en, ko, or both." >&2
  usage
  exit 1
fi

install_file() { # src dst
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ "$FORCE" -ne 1 ]; then
    echo "SKIP  $dst exists (use --force to overwrite)"
    return 0
  fi
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  echo "OK    $dst"
}

# Copy everything below the first --- line. The part above it is a maintainer
# header that must not reach the always-on context.
extract_block() { # src dst
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ "$FORCE" -ne 1 ]; then
    echo "SKIP  $dst exists (use --force to overwrite)"
    return 0
  fi
  mkdir -p "$(dirname "$dst")"
  awk 'flag { print } /^---[[:space:]]*$/ && !flag { flag = 1 }' "$src" > "$dst"
  echo "OK    $dst (header stripped)"
}

if [ "$DO_SKILL" -eq 1 ]; then
  dest="$SKILLS_DIR/asd-ste100"
  install_file "$SCRIPT_DIR/SKILL.md" "$dest/SKILL.md"
  install_file "$SCRIPT_DIR/LICENSE" "$dest/LICENSE"
  for f in "$SCRIPT_DIR"/references/*.md; do
    install_file "$f" "$dest/references/$(basename "$f")"
  done
  for f in "$SCRIPT_DIR"/examples/*.md; do
    install_file "$f" "$dest/examples/$(basename "$f")"
  done
fi

for lang in "${LANGS[@]}"; do
  suffix=""
  [ "$lang" = "ko" ] && suffix="-ko"
  if [ "$DO_RULES" -eq 1 ]; then
    extract_block "$SCRIPT_DIR/assets/distilled-rules${suffix}.md" "$RULES_DIR/ste-writing-${lang}.md"
  fi
  if [ "$DO_COMMAND" -eq 1 ]; then
    if [ ${#LANGS[@]} -eq 1 ] || [ "$lang" = "en" ]; then
      cmd_name="ste.md"
    else
      cmd_name="ste-ko.md"
    fi
    install_file "$SCRIPT_DIR/assets/ste-refresh${suffix}.md" "$COMMANDS_DIR/$cmd_name"
  fi
done

echo
if [ "$DO_RULES" -eq 1 ] && [ ${#LANGS[@]} -gt 1 ]; then
  echo "Note: you installed both language blocks. The Korean block already"
  echo "carries an English appendix - most setups need only one block."
fi
echo "Done. If you already keep the always-on block under another file name,"
echo "remove one copy: loading the same rules twice wastes tokens every session."
