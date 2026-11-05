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

> **Neu hier?** Die [Schritt-für-Schritt-Anleitung](ANLEITUNG.md) erklärt alles von der Installation bis zum fertigen Video.

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
3. **Bilder mit ChatGPT (optional).** Hast du ChatGPT Plus oder höher, erzeugt
   der Skill Bilder über Codex mit deinem ChatGPT-Abo (gpt-image-2) – ohne
   API-Key und ohne Higgsfield-Credits. Funktioniert in Codex direkt und in
   Claude Code über das Skript `codex_image.sh`.
4. **Prompt bauen.** Kurzes Interview: Thema, Ziel, Länge, Format, Branding,
   Referenz, Ton und – am wichtigsten – woran du erkennst, dass das Video gut ist.
5. **Bauen & prüfen.** Nach deinem OK baut der Agent das Video, rendert ein
   Kontaktbild aus Einzelbildern und prüft Lesbarkeit, Bewegung und Branding,
   bevor er „fertig“ meldet.

Deine Einstellungen landen in `~/.motion-studio.json`; beim nächsten Video geht
es direkt mit dem Prompt los.

## Voraussetzungen

- Claude Code oder Codex
- Node.js 22+, ffmpeg, git (der Skill prüft das und hilft beim Installieren)
- Optional: Higgsfield-Konto mit Credits; Python für Transkription (Longform → Short)
- Optional für Bilder über ChatGPT: ChatGPT Plus/Pro/Business/Enterprise und die
  Codex CLI (`npm i -g @openai/codex`, dann `codex login` mit ChatGPT)

## Aufbau

```
.claude-plugin/                   Plugin- und Marketplace-Manifest
ANLEITUNG.md                      Schritt-für-Schritt-Anleitung
skills/motion-studio/
├── SKILL.md                      Ablauf in drei Teilen
├── references/
│   ├── setup.md                  Prüfungen, Framework, Higgsfield
│   ├── prompt-interview.md       Fragen, Prompt-Vorlage, Beispiele, Tipps
│   └── troubleshooting.md        Was tun, wenn's klemmt
└── scripts/
    ├── check_env.sh              Voraussetzungen als Tabelle
    ├── codex_image.sh            Bild über ChatGPT-Abo (Codex, gpt-image-2)
    ├── preview_frames.sh         Kontaktbild zur Selbstprüfung
    └── transcribe.py             Transkript mit Wortzeiten (faster-whisper)
```

## Hinweise

- **Remotion** ist kostenlos für Einzelpersonen und Firmen bis 3 Mitarbeitende,
  größere Firmen brauchen eine Lizenz.
- **Higgsfield** kostet Credits; der Skill fragt vor jeder Generierung.
- **Bilder über ChatGPT/Codex** verbrauchen dein ChatGPT-Kontingent (nicht im
  Free-Plan verfügbar). Der Skill zeigt vorher, welche Bilder er erzeugen will.
- **Affiliate-Link:** Wer noch kein Higgsfield-Konto hat, bekommt im Setup einen
  Anmeldelink ([higgsfield.ai](https://higgsfield.ai?fpr=gerald-721ddc)). Das ist
  ein Affiliate-Link: Schließt du darüber ein Abo ab, bekomme ich eine Provision,
  für dich ändert sich am Preis nichts.

## English

Motion Studio is a Claude Code skill (also usable in Codex) that sets up
code-based video creation (HyperFrames, Remotion or Tesseract, plus optional
Higgsfield for images, clips, voices and music, or image generation through
your ChatGPT subscription via Codex / gpt-image-2), interviews you to write a
goal-driven video prompt, and self-checks the rendered video via a frame contact
sheet before reporting it done. Install with
`claude plugin marketplace add Geraldki94/claude_skill_motion` or
`npx skills add Geraldki94/claude_skill_motion -g -y`.

## Credits & Lizenz

Basiert auf [motion-fabrik](https://github.com/Arnie936/motion-fabrik) von
Arnold Oberleiter (MIT). Erweitert und angepasst von Geraldki94.
MIT, siehe [LICENSE](LICENSE).

---

**Community:** Austausch, Beispiele und Hilfe rund um Claude, KI-Videos und
Motion Design gibt es in meiner Skool-Community
**KI Innovation**: [skool.com/ki-innovation-2339](https://www.skool.com/ki-innovation-2339/about)
