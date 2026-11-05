# Wenn etwas klemmt

**Neu installierte Skills oder Plugins tauchen nicht auf.**
Die Liste wird beim Start einer Sitzung gelesen. Neue Sitzung starten.

**`higgsfield` wird nicht gefunden.**
Das globale npm-Verzeichnis liegt nicht im Pfad. `npm prefix -g` zeigt, wohin
installiert wurde. Unter Windows hilft oft schon ein neues Terminal.

**Higgsfield: „Authorization with the MCP server failed“ oder „Session expired“.**
Token abgelaufen. CLI: `higgsfield auth login` wiederholen. Connector: in den
Einstellungen trennen und neu verbinden.

**`npx skills add` findet nichts oder fragt endlos.**
Mit `-l` statt `-y` listet der Befehl auf, was im Repo liegt. Liegt ein Skill tief
in Unterordnern, hilft `--full-depth`.

**HyperFrames rendert nicht.**
`node --version` muss mindestens 22 sein, und `ffmpeg` muss im Pfad liegen.
`npx hyperframes check` im Projekt zeigt Fehler im Video selbst.

**Transkription für fertige Videos (Longform → Short).**
`hyperframes transcribe` braucht whisper-cpp und kann ohne das stillschweigend
scheitern. Zuverlässiger ist das mitgelieferte Skript (faster-whisper über uv):

```bash
pip install uv          # einmalig, falls uv fehlt
uv run --with faster-whisper --with "av<14" python scripts/transcribe.py video.mp4 --lang de
```

Ergebnis: `video.transcript.json` mit Segmenten und Wortzeiten. Kann PyAV die
Datei nicht lesen, zieht das Skript den Ton automatisch per ffmpeg heraus.

**Generierte Soundeffekte sind kaum hörbar.**
Manche Modelle liefern sehr leise Dateien. Mit ffmpeg normalisieren
(`-af loudnorm=I=-16`) oder freie Sounds nehmen.

**Die Stimme spricht ein Wort falsch aus.**
Das Wort im Sprechtext lautmalerisch schreiben (z. B. „n-eight-n“ statt „n8n“)
und nur diesen Satz neu generieren.

**Das Video wirkt wie eine Präsentation mit Standbildern.**
Im Feedback sagen: „Auf jeder Ebene soll sich etwas bewegen, Animationen sollen
auf dem gesprochenen Wort sitzen.“

**Die Selbstprüfung zeigt schwarze oder leere Bilder.**
Oft fehlen Schriften/Assets beim Rendern oder eine Animation startet zu spät.
Im Projekt-Preview die betroffene Zeitmarke (steht oben links im Kontaktbild)
ansehen und gezielt diese Szene korrigieren.

**`codex_image.sh` meldet „nicht mit einem ChatGPT-Account angemeldet“ (Exit 4).**
`codex login` ausführen und **Sign in with ChatGPT** wählen. Ohne Browser:
`codex login --device-auth`. Steht bei `codex login status` „API key“, läuft
Codex über API-Kosten: abmelden (`codex logout`) und mit ChatGPT neu anmelden.

**`codex_image.sh` meldet „Kein Bild entstanden“ (Exit 5).**
- Free-Plan: Bilderzeugung in Codex gibt es erst ab ChatGPT Plus.
- Kontingent aufgebraucht: später erneut versuchen oder Higgsfield nutzen.
- „The built-in image tool is not exposed in this session“: Codex aktualisieren
  (`npm i -g @openai/codex@latest`) und `codex features enable image_generation`.
- Codex-Ausgabe oberhalb der Meldung lesen, dort steht meist der eigentliche Grund.

**Cloud-Umgebung (claude.ai/code) mit eingeschränktem Netzwerk.**
Dort sind nur freigegebene Domains erreichbar. Typische Sperren und was freigegeben
werden muss (Umgebung → Edit → Network access → Allowed domains):
- Bilder über ChatGPT/Codex: `auth.openai.com`, `chatgpt.com`, `api.openai.com`
- Higgsfield-Ergebnisse herunterladen: die CDN-Domain aus der Ergebnis-URL
  (z. B. `d8j0ntlcm91z4.cloudfront.net`, `cdn.higgsfield.ai`)
- HyperFrames lädt GSAP standardmäßig von `cdn.jsdelivr.net`. Robuster: GSAP per
  npm holen und lokal einbinden (`npm i gsap`, `gsap.min.js` nach `assets/`,
  `<script src="assets/gsap.min.js">`).
`codex login --device-auth` funktioniert ohne Browser auf der Maschine: Link und
Code werden angezeigt, die Anmeldung passiert auf dem eigenen Gerät.
