#!/usr/bin/env bash
# Erzeugt eine Sprecherstimme über Fish Audio (Text-to-Speech) und speichert sie als MP3.
#
# Nutzung:
#   fish_tts.sh --text "Sprechertext" --out assets/voice.mp3 [--voice <reference_id>] [--model s2.1-pro-free]
#   fish_tts.sh --file sprechertext.txt --out assets/voice.mp3
#
# Der API-Key kommt aus der Umgebungsvariable FISH_API_KEY und steht NIE im Skript,
# im Projekt oder im Repo. In einer Claude-Cloud-Umgebung, in der der Key als
# Netzwerk-Secret für api.fish.audio hinterlegt ist, reicht FISH_API_KEY=proxy-injected.
#
# Exit-Codes: 0 ok · 2 falsche Nutzung · 3 kein Key · 4 API-Fehler · 5 keine gültige Audiodatei
set -euo pipefail

text="" file="" out="" voice="" model="${FISH_MODEL:-s2.1-pro-free}"
while [ $# -gt 0 ]; do
  case "$1" in
    --text) text=$2; shift 2 ;;
    --file) file=$2; shift 2 ;;
    --out) out=$2; shift 2 ;;
    --voice) voice=$2; shift 2 ;;
    --model) model=$2; shift 2 ;;
    -h|--help) sed -n 2,12p "$0"; exit 0 ;;
    *) echo "Unbekannte Option: $1" >&2; exit 2 ;;
  esac
done
[ -n "$file" ] && { [ -f "$file" ] || { echo "Datei nicht gefunden: $file" >&2; exit 2; }; text=$(cat "$file"); }
[ -n "$text" ] && [ -n "$out" ] || { echo "Nutzung: fish_tts.sh --text \"...\" --out voice.mp3 [--voice ID]" >&2; exit 2; }

if [ -z "${FISH_API_KEY:-}" ]; then
  echo "FISH_API_KEY fehlt. Key unter fish.audio → API Keys erstellen, dann z. B.:" >&2
  echo "  export FISH_API_KEY=...   (nie in Dateien oder Repos speichern)" >&2
  exit 3
fi

mkdir -p "$(dirname "$out")"
body=$(python3 -c 'import json,sys; d={"text":sys.argv[1],"format":"mp3"}
if sys.argv[2]: d["reference_id"]=sys.argv[2]
print(json.dumps(d))' "$text" "$voice")

tmp="$out.part"
code=$(curl -sS https://api.fish.audio/v1/tts \
  -H "Authorization: Bearer $FISH_API_KEY" \
  -H "Content-Type: application/json" \
  -H "model: $model" \
  -d "$body" -o "$tmp" -w "%{http_code}") || { rm -f "$tmp"; echo "Verbindung zu api.fish.audio fehlgeschlagen." >&2; exit 4; }

if [ "$code" != "200" ]; then
  echo "Fish Audio antwortete mit HTTP $code:" >&2; head -c 400 "$tmp" >&2; echo >&2
  rm -f "$tmp"
  case "$code" in
    401|403) echo "→ Key ungültig oder ohne Berechtigung." >&2 ;;
    402) echo "→ Guthaben/Kontingent bei Fish Audio aufgebraucht." >&2 ;;
    429) echo "→ Zu viele Anfragen, kurz warten und erneut versuchen." >&2 ;;
  esac
  exit 4
fi
mv "$tmp" "$out"

if command -v ffprobe >/dev/null 2>&1; then
  dur=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$out" 2>/dev/null || true)
  [ -n "$dur" ] || { echo "Antwort ist keine gültige Audiodatei: $out" >&2; exit 5; }
  echo "OK: $out (${dur}s, Modell $model${voice:+, Stimme $voice})"
else
  echo "OK: $out"
fi
