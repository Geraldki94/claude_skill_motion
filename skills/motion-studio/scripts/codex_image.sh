#!/usr/bin/env bash
# Erzeugt ein Bild über Codex (eingebautes Bild-Werkzeug, gpt-image-2) mit dem
# ChatGPT-Abo der Person. Kein API-Key, keine Higgsfield-Credits.
#
# Nutzung:
#   codex_image.sh --prompt "..." --out assets/hero.png [--aspect 16:9] [--ref bild.png]... [--transparent]
#
# Voraussetzungen: Codex CLI, angemeldet mit ChatGPT (`codex login`), bezahltes
# ChatGPT-Abo (Plus, Pro, Business, Enterprise). Verbraucht ChatGPT-Kontingent.
# Exit-Codes: 0 ok · 2 falsche Nutzung · 3 Codex fehlt · 4 nicht mit ChatGPT angemeldet · 5 kein Bild entstanden
set -euo pipefail

prompt="" out="" aspect="" transparent=0
refs=()
while [ $# -gt 0 ]; do
  case "$1" in
    --prompt) prompt=$2; shift 2 ;;
    --out) out=$2; shift 2 ;;
    --aspect) aspect=$2; shift 2 ;;
    --ref) refs+=("$2"); shift 2 ;;
    --transparent) transparent=1; shift ;;
    -h|--help) sed -n 2,11p "$0"; exit 0 ;;
    *) echo "Unbekannte Option: $1" >&2; exit 2 ;;
  esac
done
[ -n "$prompt" ] && [ -n "$out" ] || { echo "Nutzung: codex_image.sh --prompt \"...\" --out pfad.png [--aspect 16:9] [--ref bild]..." >&2; exit 2; }

command -v codex >/dev/null 2>&1 || { echo "Codex CLI fehlt. Installieren: npm i -g @openai/codex, dann: codex login" >&2; exit 3; }

status=$(env -u OPENAI_API_KEY codex login status 2>&1 || true)
if ! printf '%s' "$status" | grep -qi "chatgpt"; then
  echo "Codex ist nicht mit einem ChatGPT-Account angemeldet ($status)." >&2
  echo "Anmelden: codex login  (im Browser 'Sign in with ChatGPT' wählen)" >&2
  exit 4
fi

[ -e "$out" ] && { echo "Datei existiert schon: $out (anderen Namen wählen oder vorher löschen)" >&2; exit 2; }
mkdir -p "$(dirname "$out")"
outdir=$(cd "$(dirname "$out")" && pwd)
outname=$(basename "$out")

img_args=()
ref_note=""
for r in "${refs[@]+"${refs[@]}"}"; do
  [ -f "$r" ] || { echo "Referenzbild nicht gefunden: $r" >&2; exit 2; }
  img_args+=(-i "$(cd "$(dirname "$r")" && pwd)/$(basename "$r")")
  ref_note="Use the attached image(s) as visual reference (style, subject, branding). "
done

extra=""
[ -n "$aspect" ] && extra+="Aspect ratio: $aspect. "
[ "$transparent" = 1 ] && extra+="Transparent background (PNG with alpha). "

instruction="Use your built-in image generation tool (\$imagegen, gpt-image-2) to create exactly ONE image. \
Do not write code to draw it and do not use any other image source. ${ref_note}${extra}
Image description:
${prompt}

When the image is generated, save it as PNG at: ./${outname}
(current working directory). Do nothing else. Finally reply with only the saved file path."

echo "Erzeuge Bild über Codex/ChatGPT … (kann 30–120 s dauern)" >&2
# Prompt über stdin: -i nimmt mehrere Dateien und würde ein Prompt-Argument schlucken.
env -u OPENAI_API_KEY -u OPENAI_BASE_URL codex exec \
  --skip-git-repo-check --ephemeral \
  --enable image_generation \
  -s workspace-write -C "$outdir" \
  "${img_args[@]+"${img_args[@]}"}" \
  < <(printf '%s\n' "$instruction") >&2 || true

target="$outdir/$outname"
if [ ! -s "$target" ]; then
  echo "Kein Bild entstanden. Mögliche Gründe: ChatGPT-Plan ohne Bilderzeugung (Free)," >&2
  echo "Kontingent aufgebraucht, oder Bild-Werkzeug in dieser Codex-Version nicht aktiv" >&2
  echo "(codex features enable image_generation, Codex aktualisieren). Siehe troubleshooting.md." >&2
  exit 5
fi
if command -v ffprobe >/dev/null 2>&1; then
  dims=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0:s=x "$target" 2>/dev/null || true)
  [ -n "$dims" ] || { echo "Datei ist kein lesbares Bild: $target" >&2; exit 5; }
  echo "OK: $target ($dims)"
else
  echo "OK: $target"
fi
