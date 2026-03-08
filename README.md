# HY-Motion Pinokio Package (Windows)

Pinokio v6 launcher package for Tencent HY-Motion 1.0.

## What this package does

- Installs HY-Motion-1.0 into `app/`
- Creates a Python 3.10/3.11/3.12 venv at `app/env`
- Installs pinned dependencies and compatibility patches
- Downloads HY-Motion checkpoints to `app/ckpts/tencent`
- Starts Gradio in **rewrite-disabled mode** by default (VRAM-safe)

## Requirements

- Windows 10/11
- NVIDIA GPU + CUDA-capable drivers
- Pinokio v6.x
- Internet connection
- Free disk space (large; model files are several GB)

## Install (end user)

1. Place folder `hy-motion.pinokio` inside your Pinokio `api/` directory.
2. In Pinokio, open `hy-motion.pinokio`.
3. Click `Install` and wait for `Install complete.`
4. Click `Start (Lite Model)` first.

## Start behavior

- `Start (Lite Model)` and `Start (Full Model)` launch with prompt engineering disabled:
  - `DISABLE_PROMPT_ENGINEERING=1`
  - `--disable_rewrite --disable_duration_est`
- This avoids common VRAM crashes from Text2MotionPrompter.

## Optional prompt-rewriter download

By default, the huge optional Text2MotionPrompter model is skipped.

If you want to download it anyway, run install/update with env var:

```bat
set HYMOTION_DOWNLOAD_REWRITER=1
```

## Troubleshooting

### `ModuleNotFoundError` (example: `transformers`, `torchdiffeq`)

Run in `...\hy-motion.pinokio\app`:

```bat
env\Scripts\python.exe -m pip install transformers==4.53.3 torchdiffeq==0.2.5
env\Scripts\python.exe -m pip install huggingface-hub==0.30.0 --force-reinstall --no-deps
```

### Gradio error about `concurrency_limit`

Patched automatically by `patch_gradio_compat.py` during install/update.

### Start button says path not found

Your venv is missing. Re-run `Install`.

## Share with other users

1. Zip the folder `hy-motion.pinokio`.
2. Publish it in a GitHub repo or GitHub release asset.
3. Tell users to extract it into their Pinokio `api/` folder.
4. Share this README with the package.

## Included files

- `pinokio.js`
- `install.js` / `install.cmd`
- `start_full.js`
- `start_lite.js`
- `stop.js`
- `update.js` / `update.cmd`
- `reset.js`
- `patch_gradio_compat.py`
- `filter_requirements.py`
- `download_models.py`
- `icon.png`
