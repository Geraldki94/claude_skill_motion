#!/usr/bin/env bash
# Prüft die Voraussetzungen für Motion Studio und gibt eine Markdown-Tabelle aus.
# Exit-Code 0 = alles Pflichtige da, 1 = etwas Pflichtiges fehlt.

missing=0

ver() { "$@" 2>&1 | head -n1; }

row() { # name status detail purpose
  printf '| %s | %s | %s | %s |\n' "$1" "$2" "$3" "$4"
}

case "$(uname -s 2>/dev/null)" in
  Linux*)  os="Linux" ;;
  Darwin*) os="macOS" ;;
  MINGW*|MSYS*|CYGWIN*) os="Windows" ;;
  *) os="unbekannt" ;;
esac
echo "Betriebssystem: $os"
echo
echo "| Werkzeug | Status | Version | Wofür |"
echo "|---|---|---|---|"

if command -v node >/dev/null 2>&1; then
  v=$(node --version)
  major=${v#v}; major=${major%%.*}
  if [ "$major" -ge 22 ] 2>/dev/null; then
    row node "ok" "$v" "HyperFrames (v22+), Remotion, Higgsfield CLI"
  elif [ "$major" -ge 18 ] 2>/dev/null; then
    row node "zu alt für HyperFrames" "$v" "HyperFrames braucht v22+, Remotion/Higgsfield gehen ab v18"
  else
    row node "zu alt" "$v" "mindestens v18, für HyperFrames v22+"; missing=1
  fi
else
  row node "fehlt" "-" "HyperFrames, Remotion, Higgsfield CLI, Skill-Installation"; missing=1
fi

if command -v npm >/dev/null 2>&1; then
  row npm "ok" "$(npm --version)" "Pakete und Skills installieren"
else
  row npm "fehlt" "-" "kommt mit Node.js"; missing=1
fi

if command -v ffmpeg >/dev/null 2>&1; then
  row ffmpeg "ok" "$(ver ffmpeg -version | awk '{print $3}')" "Rendern, Schneiden, Ton, Kontaktbilder"
else
  row ffmpeg "fehlt" "-" "Rendern, Schneiden, Ton"; missing=1
fi

if command -v git >/dev/null 2>&1; then
  row git "ok" "$(ver git --version | awk '{print $3}')" "Skills laden, Projekte versionieren"
else
  row git "fehlt" "-" "Skills laden, Projekte versionieren"; missing=1
fi

py=""
for c in python3 python; do
  if command -v "$c" >/dev/null 2>&1; then py=$c; break; fi
done
if [ -n "$py" ]; then
  row python "ok" "$(ver $py --version | awk '{print $2}')" "optional: Transkription (Longform → Short)"
else
  row python "fehlt (optional)" "-" "nur für Transkription fertiger Videos"
fi

if command -v higgsfield >/dev/null 2>&1; then
  row higgsfield "ok" "installiert" "optional: Bilder, Clips, Stimmen, Musik"
else
  row higgsfield "nicht installiert (optional)" "-" "optional: Bilder, Clips, Stimmen, Musik"
fi

if command -v codex >/dev/null 2>&1; then
  if codex login status 2>&1 | grep -qi chatgpt; then
    row codex "ok, mit ChatGPT angemeldet" "$(ver codex --version | awk '{print $2}')" "optional: Bilder über ChatGPT-Abo"
  else
    row codex "installiert, nicht mit ChatGPT angemeldet" "$(ver codex --version | awk '{print $2}')" "optional: Bilder über ChatGPT-Abo (codex login)"
  fi
else
  row codex "nicht installiert (optional)" "-" "optional: Bilder über ChatGPT-Abo"
fi

exit $missing
