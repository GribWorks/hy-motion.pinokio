import os
import time
from pathlib import Path

from huggingface_hub import snapshot_download


def download_with_retry(name, *, optional=False, retries=4, **kwargs):
    for attempt in range(1, retries + 1):
        try:
            print(f"[{name}] attempt {attempt}/{retries}")
            snapshot_download(**kwargs)
            print(f"[{name}] download complete")
            return True
        except Exception as exc:
            print(f"[{name}] failed on attempt {attempt}: {exc}")
            if attempt == retries:
                if optional:
                    print(f"[{name}] optional model failed after retries; continuing with fallback mode")
                    return False
                raise
            time.sleep(min(60, attempt * 10))


def main():
    download_with_retry(
        "hy-motion-checkpoints",
        repo_id="tencent/HY-Motion-1.0",
        local_dir="app/ckpts/tencent",
        allow_patterns=["HY-Motion-1.0/*", "HY-Motion-1.0-Lite/*", "config.json"],
        max_workers=1,
    )

    # Default off: prompt rewriter model is huge and often unusable on limited VRAM.
    want_rewriter = os.environ.get("HYMOTION_DOWNLOAD_REWRITER", "0") == "1"

    marker = Path("app/ckpts/Text2MotionPrompter/.download_failed")
    if want_rewriter:
        rewrite_ok = download_with_retry(
            "text2motion-prompter",
            optional=True,
            repo_id="Text2MotionPrompter/Text2MotionPrompter",
            local_dir="app/ckpts/Text2MotionPrompter",
            max_workers=1,
        )
        if rewrite_ok:
            marker.unlink(missing_ok=True)
        else:
            marker.parent.mkdir(parents=True, exist_ok=True)
            marker.write_text("optional prompt rewrite model failed to fully download\n", encoding="ascii")
    else:
        print("[text2motion-prompter] skipped (set HYMOTION_DOWNLOAD_REWRITER=1 to enable download)")

    print("Model download step complete.")


if __name__ == "__main__":
    main()
