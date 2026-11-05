#!/usr/bin/env bash
# Erzeugt ein Kontaktbild (Raster aus Einzelbildern) eines Videos zur Selbstprüfung.
# Nutzung: preview_frames.sh <video> [anzahl_bilder=12] [spalten=4]
# Ausgabe: <video ohne Endung>_contact.png
set -euo pipefail

video=${1:?Nutzung: preview_frames.sh <video> [anzahl] [spalten]}
count=${2:-12}
cols=${3:-4}
rows=$(( (count + cols - 1) / cols ))
out="${video%.*}_contact.png"

dur=$(ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "$video")
# Bildrate so wählen, dass genau $count Bilder gleichmäßig über das Video verteilt sind.
fps=$(awk -v n="$count" -v d="$dur" 'BEGIN { printf "%.6f", n / d }')

ffmpeg -v error -y -i "$video" \
  -vf "fps=${fps},scale=480:-2,drawtext=text='%{pts\:hms}':x=8:y=8:fontsize=20:fontcolor=white:box=1:boxcolor=black@0.6,tile=${cols}x${rows}:padding=4:color=black" \
  -frames:v 1 "$out" 2>/dev/null \
|| ffmpeg -v error -y -i "$video" \
  -vf "fps=${fps},scale=480:-2,tile=${cols}x${rows}:padding=4:color=black" \
  -frames:v 1 "$out"

echo "Dauer: ${dur}s · ${count} Bilder · Kontaktbild: $out"
