"""Transkribiert ein Video mit Wortzeiten (faster-whisper) und schreibt JSON.

Nutzung (ohne globale Installation, über uv):
    uv run --with faster-whisper --with "av<14" python transcribe.py video.mp4 [--lang de] [--model medium]

Ausgabe: <video>.transcript.json mit Segmenten und Wörtern (start/end in Sekunden).
Scheitert das Einlesen über PyAV, wird der Ton per ffmpeg als 16-kHz-Mono-WAV extrahiert.
"""

import argparse
import json
import subprocess
import sys
import tempfile
from pathlib import Path


def load_audio_fallback(path: Path):
    import numpy as np

    with tempfile.TemporaryDirectory() as tmp:
        wav = Path(tmp) / "audio.wav"
        subprocess.run(
            ["ffmpeg", "-v", "error", "-y", "-i", str(path), "-ac", "1", "-ar", "16000",
             "-f", "s16le", str(wav)],
            check=True,
        )
        data = np.frombuffer(wav.read_bytes(), dtype=np.int16)
    return data.astype(np.float32) / 32768.0


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("video", type=Path)
    ap.add_argument("--lang", default=None, help="Sprache, z. B. de oder en (Standard: automatisch)")
    ap.add_argument("--model", default="medium")
    args = ap.parse_args()

    from faster_whisper import WhisperModel

    model = WhisperModel(args.model, device="auto", compute_type="auto")
    opts = dict(language=args.lang, word_timestamps=True, vad_filter=True)
    try:
        segments, info = model.transcribe(str(args.video), **opts)
        segments = list(segments)
    except Exception as exc:  # PyAV kann manche Container nicht lesen
        print(f"Direktes Einlesen fehlgeschlagen ({exc}), nutze ffmpeg-Fallback …", file=sys.stderr)
        segments, info = model.transcribe(load_audio_fallback(args.video), **opts)
        segments = list(segments)

    result = {
        "language": info.language,
        "duration": info.duration,
        "segments": [
            {
                "start": round(s.start, 3),
                "end": round(s.end, 3),
                "text": s.text.strip(),
                "words": [
                    {"start": round(w.start, 3), "end": round(w.end, 3), "word": w.word.strip()}
                    for w in (s.words or [])
                ],
            }
            for s in segments
        ],
    }
    out = args.video.with_suffix(".transcript.json")
    out.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"{len(result['segments'])} Segmente → {out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
