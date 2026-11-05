# Anleitung: Motion Studio Schritt für Schritt

Diese Anleitung bringt dich vom leeren Rechner zum ersten fertigen Video.
Du musst nicht programmieren können. Claude erledigt die Arbeit, du triffst
nur die Entscheidungen.

**Inhalt**

1. [Was du brauchst](#1-was-du-brauchst)
2. [Skill installieren](#2-skill-installieren)
3. [Einrichtung (einmalig)](#3-einrichtung-einmalig)
4. [Bilder: ChatGPT, Higgsfield oder eigene](#4-bilder-chatgpt-higgsfield-oder-eigene)
5. [Dein erstes Video](#5-dein-erstes-video)
6. [Video verbessern](#6-video-verbessern)
7. [Lange Videos in Shorts schneiden](#7-lange-videos-in-shorts-schneiden)
8. [Was ist alles im Skill?](#8-was-ist-alles-im-skill)
9. [Häufige Probleme](#9-häufige-probleme)

---

## 1. Was du brauchst

| Was | Pflicht? | Wofür |
|---|---|---|
| **Claude Code** (oder Codex) | ja | Der Agent, der das Video baut |
| **Node.js 22+**, **ffmpeg**, **git** | ja | Videos rendern und schneiden. Der Skill prüft das und hilft beim Installieren. |
| **ChatGPT Plus** (oder höher) + **Codex CLI** | optional | Bilder über dein ChatGPT-Abo erzeugen |
| **Higgsfield-Konto** | optional | Videoclips, Stimmen, Musik, Soundeffekte (kostet Credits) |
| **Python** | optional | Nur, um lange Videos in Shorts zu schneiden |

Ohne die optionalen Teile funktioniert der Skill auch: Dann nutzt du eigene
Bilder, Logos und Musik.

---

## 2. Skill installieren

Öffne ein Terminal und starte Claude Code (`claude`). Dann eine der drei Varianten:

**A) Einfach fragen (am leichtesten)**

Schreib in Claude Code:

> Installiere bitte https://github.com/Geraldki94/claude_skill_motion

**B) Als Plugin (empfohlen, lässt sich später aktualisieren)**

```bash
claude plugin marketplace add Geraldki94/claude_skill_motion
```

```bash
claude plugin install motion-studio@claude-skill-motion
```

**C) Als Skill (auch für Codex)**

```bash
npx skills add Geraldki94/claude_skill_motion -g -y
```

Danach Claude Code **neu starten** (`/exit`, dann wieder `claude`).

**Update auf eine neue Version (bei Variante B):**

```bash
claude plugin marketplace update claude-skill-motion
```

---

## 3. Einrichtung (einmalig)

Schreib in Claude Code einfach:

> Motion Studio

Claude führt dich durch fünf kurze Schritte. Bei jeder Frage siehst du
Auswahlknöpfe, die Empfehlung steht oben.

1. **Prüfung:** Claude prüft, was auf deinem Rechner schon da ist, und zeigt eine
   Tabelle. Fehlt etwas, fragt Claude, ob es installiert werden soll.
2. **Video-Framework:** Womit werden Videos gebaut?
   - **HyperFrames** (empfohlen): Videos aus HTML, kostenlos, viele fertige Bausteine
   - **Remotion**: Videos aus React. Für Firmen ab 4 Mitarbeitenden kostenpflichtig.
   - **Tesseract**: eigener Editor im Browser
   - **Nichts**: geht auch, dauert aber länger
3. **Higgsfield:** Willst du Videoclips, Stimmen, Musik und Soundeffekte erzeugen?
   Wenn ja, meldest du dich einmal im Browser an.
4. **Bildquelle:** ChatGPT über Codex, Higgsfield oder nur eigene Bilder
   (siehe [Abschnitt 4](#4-bilder-chatgpt-higgsfield-oder-eigene)).
5. **Speichern:** Deine Antworten landen in `~/.motion-studio.json`. Beim nächsten
   Mal überspringt Claude die Einrichtung.

Wurde etwas installiert, sagt Claude: „Starte eine neue Sitzung“. Dann
`/exit`, `claude` starten und wieder **Motion Studio** schreiben.

---

## 4. Bilder: ChatGPT, Higgsfield oder eigene

| Bildquelle | Kosten | Gut für |
|---|---|---|
| **ChatGPT über Codex** | dein ChatGPT-Abo (Kontingent), keine Extra-Kosten | Wer ChatGPT Plus/Pro schon hat |
| **Higgsfield** | Credits, Kosten werden vorher angezeigt | Mehr Bildmodelle, alles aus einer Hand mit Clips und Stimmen |
| **Eigene Bilder** | kostenlos | Echte Logos, Screenshots, Fotos (oft am besten!) |

### ChatGPT über Codex einrichten

Einmalig im Terminal:

```bash
npm i -g @openai/codex
```

```bash
codex login
```

Im Browser **„Sign in with ChatGPT“** wählen (nicht API-Key). Kontrolle:

```bash
codex login status
```

Dort muss „ChatGPT“ stehen. Fertig: Ab jetzt erzeugt Claude Bilder über dein Abo.
Vor dem Erzeugen zeigt Claude dir die Liste der geplanten Bilder und fragt nach.

> Im **Free-Plan** von ChatGPT gibt es keine Bilderzeugung in Codex.

### Eigene Bilder nutzen

Leg Logos, Fotos, Screenshots oder Musik in den Ordner `assets/` deines
Video-Projekts oder nenn Claude einfach den Pfad zur Datei.

---

## 5. Dein erstes Video

Schreib **Motion Studio**. Claude stellt dir ein paar Fragen:

| Frage | Beispiel-Antwort |
|---|---|
| Worum geht es? | „Mein Online-Kurs zu Excel“ oder ein Link zu deiner Webseite |
| Ziel und Zielgruppe? | „Werbespot für Instagram, Zielgruppe Selbstständige“ |
| Wie lang? | 15 s, 30 s, 60 s |
| Format? | 16:9 (YouTube), 9:16 (Reels/TikTok/Shorts), 1:1 oder 4:5 (Feed) |
| Farben / Branding? | Logo hochladen, Webseite als Vorbild, oder „freie Hand“ |
| Referenz? | Ein Video oder Bild, das dir gefällt |
| Ton? | Sprecherstimme (Sprache), Musik, Soundeffekte |
| **Wann ist es gut?** | „Jemand ohne Vorwissen versteht, was mein Kurs bringt.“ |

Die letzte Frage ist die wichtigste: Daran misst Claude das Ergebnis.

Dann passiert Folgendes:

1. Claude zeigt dir den fertigen **Prompt** und speichert ihn als `prompt.md`.
2. Du sagst **„Ja“** oder was geändert werden soll.
3. Kostet etwas (Higgsfield-Credits, ChatGPT-Bilder), zeigt Claude vorher, was
   erzeugt wird, und wartet auf dein Okay.
4. Claude baut das Video.
5. Claude **prüft das Video selbst**: Es erzeugt ein Übersichtsbild mit 12
   Einzelbildern und kontrolliert Lesbarkeit, Bewegung und Branding. Erst dann
   meldet es „fertig“.

Das Video liegt danach im Projektordner (z. B. `video-excel-kurs/`).

### Beispiel-Prompts, so kurz dürfen sie sein

> Mach ein 30-Sekunden-Werbevideo für meinen Excel-Kurs, 9:16 für Reels.
> Nimm HyperFrames, meine Farben aus dem Logo in assets/, Bilder über ChatGPT.
> Ziel erreicht, wenn man nach 3 Sekunden weiterschauen will.

> Erstelle ein 15-Sekunden-Motion-Graphics-Video, das zeigt, was du im Motion
> Design kannst. Ziel erreicht, wenn ein Designer „wow“ sagt. Sei kreativ.

---

## 6. Video verbessern

Weil alles aus Code besteht, ändert Claude nur die Stelle, die du nennst.
Gib **konkretes** Feedback:

- „Die Musik ist zu laut.“
- „Szene 3 ist zu lang, kürze sie auf 2 Sekunden.“
- „Das Wort ‚n8n‘ wird falsch ausgesprochen.“
- „Auf jeder Szene soll sich etwas bewegen.“

**Tipps:**

- **Neuer Chat pro Video.** Alte Videos im Gespräch lenken ab.
- **Aufwand „Medium“** reicht fast immer.
- **Eigene Assets schlagen generierte:** echtes Logo, echte Screenshots.

---

## 7. Lange Videos in Shorts schneiden

Schreib: „Motion Studio, mach aus diesem Video Shorts: `pfad/zum/video.mp4`“.

1. Claude fragt: Wie viele Shorts? Wie lang? Untertitel ja/nein, welche Farbe?
2. Claude **transkribiert** das Video mit Wortzeiten (braucht Python).
3. Claude schlägt **Storylines** vor (Hook, Kontext, Erklärung, Abschluss), du
   suchst aus.
4. Erst dann wird geschnitten.

---

## 8. Was ist alles im Skill?

```
claude_skill_motion/
├── README.md                     Überblick & Installation
├── ANLEITUNG.md                  Diese Anleitung
├── LICENSE                       MIT
├── .claude-plugin/               Damit es als Claude-Code-Plugin installierbar ist
└── skills/motion-studio/
    ├── SKILL.md                  Das „Gehirn“: Ablauf in drei Teilen
    ├── references/
    │   ├── setup.md              Einrichtung: Prüfung, Framework, Higgsfield, Bildquelle
    │   ├── prompt-interview.md   Fragen, Prompt-Vorlage, Beispiele, Tipps, Shorts
    │   └── troubleshooting.md    Lösungen für typische Probleme
    └── scripts/
        ├── check_env.sh          Prüft Node, ffmpeg, git, Python, Higgsfield, Codex
        ├── codex_image.sh        Erzeugt Bilder über dein ChatGPT-Abo (Codex)
        ├── preview_frames.sh     Übersichtsbild zur Selbstprüfung des Videos
        └── transcribe.py         Transkript mit Wortzeiten für Shorts
```

| Teil | Was er macht |
|---|---|
| **SKILL.md** | Sagt Claude, wann der Skill startet und was in welcher Reihenfolge passiert: Einrichten → Prompt bauen → Bauen & prüfen |
| **setup.md** | Genaue Befehle für jede Installation, je nach Windows, macOS oder Linux |
| **prompt-interview.md** | Die Interview-Fragen und die Vorlage, aus der dein Prompt entsteht |
| **troubleshooting.md** | Was tun bei Fehlern (siehe unten) |
| **check_env.sh** | Zeigt eine Tabelle: was da ist, was fehlt, wofür |
| **codex_image.sh** | Ein Bild pro Aufruf über ChatGPT/Codex, mit Seitenverhältnis, Referenzbild, Freisteller |
| **preview_frames.sh** | 12 Einzelbilder mit Zeitstempel auf einem Bild, damit Claude Fehler findet |
| **transcribe.py** | Wandelt Sprache im Video in Text mit genauen Zeiten um |

**Was Claude nie ohne Nachfrage tut:** etwas installieren, Credits ausgeben oder
ChatGPT-Kontingent für Bilder verbrauchen.

---

## 9. Häufige Probleme

| Problem | Lösung |
|---|---|
| Claude kennt „Motion Studio“ nicht | Claude Code neu starten (`/exit`, `claude`) |
| Programm „nicht gefunden“ nach Installation (Windows) | Neues Terminal öffnen |
| Codex: „nicht mit ChatGPT angemeldet“ | `codex login`, dann „Sign in with ChatGPT“ |
| Codex: „Kein Bild entstanden“ | Free-Plan? Kontingent leer? Codex aktualisieren: `npm i -g @openai/codex@latest` |
| Higgsfield: „Session expired“ | `higgsfield auth login` wiederholen |
| HyperFrames rendert nicht | Node mindestens Version 22? `npx hyperframes check` im Projekt |
| Video wirkt wie eine Diashow | Feedback: „Auf jeder Szene soll sich etwas bewegen, Animationen auf dem gesprochenen Wort.“ |
| Stimme spricht ein Wort falsch | Wort lautmalerisch schreiben lassen (z. B. „n-eight-n“) |

Mehr Details: [troubleshooting.md](skills/motion-studio/references/troubleshooting.md)

---

**Fragen, Beispiele, Austausch:** in der Community
[KI Innovation auf Skool](https://www.skool.com/ki-innovation-2339/about)
