# Motion Studio – Claude Skill für Videos per Code

Ein Skill für **Claude Code** (läuft auch in **Codex**), mit dem du Erklärvideos,
Werbespots, Motion Graphics und Shorts per Code baust. Er richtet alles ein,
interviewt dich zu einem guten Video-Prompt und prüft das fertige Video selbst,
bevor er es dir zeigt.

**So startest du:** Gib deinem Agenten den Link zu diesem Repo und sag:
„Ich will das installieren.“

```
https://github.com/Geraldki94/claude_skill_motion
```

## Installation

**Claude Code (als Plugin):**

```bash
claude plugin marketplace add Geraldki94/claude_skill_motion
```

```bash
claude plugin install motion-studio@claude-skill-motion
```

**Claude Code / Codex (als Skill):**

```bash
npx skills add Geraldki94/claude_skill_motion -g -y
```

**Manuell:** Ordner `skills/motion-studio` nach `~/.claude/skills/` (Claude Code)
bzw. `~/.agents/skills/` (Codex) kopieren.

Danach eine neue Sitzung starten und „Motion Studio“ schreiben.

---

> ### Für KI-Agenten
>
> Wenn dir jemand diesen Link gibt und das installieren will:
>
> 1. Frag nach, dann installiere global:
>    `npx skills add Geraldki94/claude_skill_motion -g -y`.
>    Klappt das nicht, klone das Repo und kopiere `skills/motion-studio`
>    nach `~/.claude/skills/` (Claude Code) bzw. `~/.agents/skills/` (Codex).
> 2. Warte nicht auf einen Neustart: Lies sofort `skills/motion-studio/SKILL.md`
>    und folge der Anleitung ab Teil 1.
> 3. Sprich in der Sprache der Person und frage vor jeder Installation nach.

---

## Was passiert

1. **Einrichten.** Ein Skript prüft Node.js, ffmpeg, git und Python. Dann wählst
   du ein Video-Framework: **HyperFrames** (empfohlen), **Remotion**,
   **Tesseract** oder keins.
2. **Higgsfield (optional).** Bilder, Clips, Stimmen, Musik und Soundeffekte
   generieren – über CLI oder MCP-Connector. Kosten werden vorher angezeigt.
3. **Prompt bauen.** Kurzes Interview: Thema, Ziel, Länge, Format, Branding,
   Referenz, Ton und – am wichtigsten – woran du erkennst, dass das Video gut ist.
4. **Bauen & prüfen.** Nach deinem OK baut der Agent das Video, rendert ein
   Kontaktbild aus Einzelbildern und prüft Lesbarkeit, Bewegung und Branding,
   bevor er „fertig“ meldet.

Deine Einstellungen landen in `~/.motion-studio.json`; beim nächsten Video geht
es direkt mit dem Prompt los.

## Voraussetzungen

- Claude Code oder Codex
- Node.js 22+, ffmpeg, git (der Skill prüft das und hilft beim Installieren)
- Optional: Higgsfield-Konto mit Credits; Python für Transkription (Longform → Short)

## Aufbau

```
.claude-plugin/                   Plugin- und Marketplace-Manifest
skills/motion-studio/
├── SKILL.md                      Ablauf in drei Teilen
├── references/
│   ├── setup.md                  Prüfungen, Framework, Higgsfield
│   ├── prompt-interview.md       Fragen, Prompt-Vorlage, Beispiele, Tipps
│   └── troubleshooting.md        Was tun, wenn's klemmt
└── scripts/
    ├── check_env.sh              Voraussetzungen als Tabelle
    ├── preview_frames.sh         Kontaktbild zur Selbstprüfung
    └── transcribe.py             Transkript mit Wortzeiten (faster-whisper)
```

## Hinweise

- **Remotion** ist kostenlos für Einzelpersonen und Firmen bis 3 Mitarbeitende,
  größere Firmen brauchen eine Lizenz.
- **Higgsfield** kostet Credits; der Skill fragt vor jeder Generierung.

## English

Motion Studio is a Claude Code skill (also usable in Codex) that sets up
code-based video creation (HyperFrames, Remotion or Tesseract, plus optional
Higgsfield for images, clips, voices and music), interviews you to write a
goal-driven video prompt, and self-checks the rendered video via a frame contact
sheet before reporting it done. Install with
`claude plugin marketplace add Geraldki94/claude_skill_motion` or
`npx skills add Geraldki94/claude_skill_motion -g -y`.

## Credits & Lizenz

Basiert auf [motion-fabrik](https://github.com/Arnie936/motion-fabrik) von
Arnold Oberleiter (MIT). Erweitert und angepasst von Geraldki94.
MIT, siehe [LICENSE](LICENSE).
