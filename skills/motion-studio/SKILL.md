---
name: motion-studio
description: Richtet alles ein, um mit Claude Code (oder Codex) Motion-Graphics-Videos per Code zu bauen, und führt danach durch ein kurzes Interview zu einem starken Video-Prompt. Prüft Node, ffmpeg und git per Skript, installiert auf Wunsch HyperFrames, Remotion oder Tesseract, verbindet optional Higgsfield (Bilder, Clips, Stimmen, Musik) und prüft fertige Videos anhand gerenderter Einzelbilder. Nutze den Skill, sobald jemand „Motion Studio“ oder „Motion Skill“ sagt, den Link zu diesem Repo schickt, mit Claude Erklärvideos, Werbespots, Shorts oder Motion Graphics machen will, ein Longform-Video in Shorts schneiden möchte oder HyperFrames, Remotion, Tesseract oder Higgsfield einrichten will. Also use it in English for setting up or making code-based AI videos.
license: MIT
---

# Motion Studio

Bringt jemanden in drei Teilen vom leeren Rechner zum ersten Video:

1. **Einrichten:** Voraussetzungen prüfen, Framework wählen, Higgsfield verbinden
2. **Prompt bauen:** kurzes Interview, daraus ein zielorientierter Prompt
3. **Bauen & prüfen:** Prompt abnicken, Video bauen, Einzelbilder selbst prüfen

## Grundregeln

- Sprich in der Sprache der Person. Die Texte hier sind deutsch, das ist keine Vorgabe.
- Die meisten Nutzer sind keine Entwickler: Fachbegriffe in einem Halbsatz erklären.
- **Nie etwas installieren oder Credits ausgeben, ohne vorher zu fragen.**
- Eine Entscheidung pro Frage. In Claude Code das Auswahl-Werkzeug
  (AskUserQuestion) nutzen, Empfehlung als erste Option mit „(Empfohlen)“.
  Ohne so ein Werkzeug (z. B. Codex): nummerierte Liste, auf Antwort warten.
- Was die Person schon gesagt hat, nicht noch einmal fragen.
- Fehlschläge klar benennen und den Befehl zum Nachholen nennen. Nie eine halb
  eingerichtete Umgebung als fertig melden.

Pfade zu Skripten unten sind relativ zum Ordner dieser SKILL.md.

## Gespeicherte Einstellungen

Prüfe zuerst `~/.motion-studio.json`. Existiert sie: in einer Zeile zeigen, was
drinsteht (Framework, Higgsfield, Stimme), fragen, ob das noch stimmt, und zu
Teil 2 springen. Sonst mit Teil 1 beginnen.

```json
{
  "framework": "hyperframes",
  "higgsfield": "cli",
  "voice": "",
  "language": "de",
  "setup_done": "2026-11-05"
}
```

`framework`: `hyperframes` | `remotion` | `tesseract` | `none` ·
`higgsfield`: `cli` | `mcp` | `no`

## Teil 1: Einrichten

Details, Befehle und Sonderfälle: [references/setup.md](references/setup.md).

1. **Voraussetzungen prüfen:** `bash scripts/check_env.sh` ausführen (unter
   Windows ohne Bash die Einzelbefehle aus setup.md). Ergebnis als kleine Tabelle
   zeigen (da / fehlt / wofür). Fehlendes nur nach Rückfrage installieren.
2. **Framework fragen:** HyperFrames (Empfohlen), Remotion, Tesseract oder nichts,
   je ein Satz dazu.
3. **Higgsfield fragen:** Bilder, Clips, Stimmen, Musik, Soundeffekte generieren?
   Sind in der Sitzung schon Higgsfield-MCP-Werkzeuge verfügbar (Namen mit
   `Higgsfield`), ist nichts zu installieren: nur Guthaben prüfen.
4. **Einstellungen speichern** in `~/.motion-studio.json`.
5. **Neustart-Hinweis:** Neu installierte Skills/Plugins sieht der Agent erst in
   einer neuen Sitzung. Wurde etwas installiert: kurz zusammenfassen und sagen
   „Starte eine neue Sitzung und schreib dort ‚Motion Studio‘.“ Sonst direkt weiter.

## Teil 2: Prompt bauen

Fragen, Reihenfolge, Vorlage und Beispiele:
[references/prompt-interview.md](references/prompt-interview.md).

Gefragt wird: Thema · Ziel & Zielgruppe · Länge · Format (16:9, 9:16, 1:1, 4:5) ·
Look/Branding · Referenz · Ton (Stimme, Musik, SFX) · **Erfolgskriterium**.

Der Prompt nennt Ziel, Rahmen, Geschmack und Erfolgskriterium, schreibt aber
keine Arbeitsschritte vor. Aktuelle Modelle liefern bessere Videos, wenn sie das
Ziel kennen, als wenn man jeden Schritt diktiert.

## Teil 3: Bauen & prüfen

1. Projektordner aus dem Thema anlegen (z. B. `video-gps-erklaert/`), Prompt als
   `prompt.md` speichern und zeigen.
2. „Soll ich so loslegen?“ Änderungen einarbeiten, bis die Person Ja sagt.
3. **Vor Kosten:** zeigen, was generiert wird und was es ungefähr kostet
   (`higgsfield generate cost …` bzw. Kosten-/Quote-Werkzeug des MCP), auf Ja warten.
4. Prompt ausführen, als käme er gerade vom Nutzer, mit dem gewählten Framework.
5. **Selbst prüfen, bevor du „fertig“ sagst:**
   `bash scripts/preview_frames.sh <video.mp4>` erzeugt ein Kontaktbild
   (`<video>_contact.png`) mit Einzelbildern über die ganze Länge. Ansehen und
   prüfen: Text lesbar und nicht abgeschnitten? Bewegt sich auf jeder Szene etwas?
   Branding/Farben korrekt? Erfolgskriterium erfüllt? Probleme erst beheben.
6. Am Ende kurz die Tipps aus prompt-interview.md nennen.

Fertige Videos umschneiden (Longform → Short): Abschnitt in prompt-interview.md,
Transkription mit `scripts/transcribe.py` (siehe troubleshooting.md).

Klemmt etwas: [references/troubleshooting.md](references/troubleshooting.md).
