from pathlib import Path

src = Path("app/requirements.txt")
dst = Path("app/requirements.pinokio.txt")
skip_names = {
    "torch",
    "torchvision",
    "torchaudio",
    "transformers",
    "gradio",
    "gradio-client",
    "gradio_client",
    "huggingface-hub",
    "huggingface_hub",
}


def parse_name(spec: str) -> str:
    token = spec.split("#", 1)[0].strip()
    if not token or token.startswith("--"):
        return ""
    for sep in ("==", ">=", "<=", "~=", "!=", "<", ">"):
        if sep in token:
            token = token.split(sep, 1)[0].strip()
            break
    return token.lower()


lines = []
if src.exists():
    for raw in src.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        name = parse_name(line)
        if name in skip_names:
            continue
        lines.append(line)

dst.parent.mkdir(parents=True, exist_ok=True)
dst.write_text(("\n".join(lines) + "\n") if lines else "", encoding="ascii")
print(f"Wrote {len(lines)} requirement(s) to {dst}")
