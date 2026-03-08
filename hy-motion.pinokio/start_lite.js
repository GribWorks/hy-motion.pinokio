module.exports = {
  daemon: true,
  run: [
    {
      method: "shell.run",
      params: {
        path: "app",
        message: "set DISABLE_PROMPT_ENGINEERING=1 && env\\Scripts\\python.exe gradio_app.py --model_path ckpts/tencent/HY-Motion-1.0-Lite --disable_rewrite --disable_duration_est",
        on: [
          {
            event: "/http:\\/\\/[0-9.:]+/",
            done: true
          }
        ]
      }
    }
  ]
};
