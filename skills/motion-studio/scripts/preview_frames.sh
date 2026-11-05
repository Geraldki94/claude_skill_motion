#!/usr/bin/env bash
# Erzeugt ein Kontaktbild (Raster aus Einzelbildern) eines Videos zur Selbstprüfung.
# Jedes Bild wird exakt an seinem Zeitpunkt entnommen (Mitte gleich langer Abschnitte)
# und mit genau diesem Zeitstempel beschriftet.
# Nutzung: preview_frames.sh <video> [anzahl_bilder=12] [spalten=4]
# Ausgabe: <video ohne Endung>_contact.png
set -euo pipefail

video=${1:?Nutzung: preview_frames.sh <video> [anzahl] [spalten]}
count=${2:-12}
cols=${3:-4}
rows=$(( (count + cols - 1) / cols ))
out="${video%.*}_contact.png"

dur=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$video")
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

label_ok=1
for i in $(seq 0 $((count - 1))); do
  t=$(awk -v i="$i" -v n="$count" -v d="$dur" 'BEGIN { printf "%.3f", (i + 0.5) * d / n }')
  f=$(printf '%s/f%03d.png' "$tmp" "$i")
  if [ "$label_ok" = 1 ] && ffmpeg -v error -y -ss "$t" -i "$video" -frames:v 1 \
      -vf "scale=480:-2,drawtext=text='${t}s':x=8:y=8:fontsize=22:fontcolor=white:box=1:boxcolor=black@0.6" \
      "$f" 2>/dev/null; then
    :
  else
    label_ok=0   # ffmpeg ohne drawtext/Schrift: ohne Beschriftung weiter
    ffmpeg -v error -y -ss "$t" -i "$video" -frames:v 1 -vf "scale=480:-2" "$f"
  fi
  echo "Bild $((i + 1)): ${t}s" >&2
done

ffmpeg -v error -y -framerate 1 -i "$tmp/f%03d.png" \
  -vf "tile=${cols}x${rows}:padding=4:color=black" -frames:v 1 "$out"

echo "Dauer: ${dur}s · ${count} Bilder · Kontaktbild: $out"
[ "$label_ok" = 1 ] || echo "Hinweis: ohne Zeitstempel (ffmpeg kann keinen Text zeichnen); Reihenfolge = Zeitpunkte oben." >&2
