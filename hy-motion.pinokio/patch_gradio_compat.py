from pathlib import Path

path = Path("app/gradio_app.py")
if not path.exists():
    print(f"Skip: {path} not found")
    raise SystemExit(0)

text = path.read_text(encoding="utf-8")
needle = "            concurrency_limit=NUM_WORKERS,\n"
if needle in text:
    text = text.replace(needle, "")
    path.write_text(text, encoding="utf-8")
    print("Patched gradio compatibility: removed concurrency_limit for Gradio 3.x")
else:
    print("No compatibility patch needed")
