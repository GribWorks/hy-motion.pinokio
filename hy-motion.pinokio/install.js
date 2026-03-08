module.exports = {
  run: [
    {
      method: "script.stop",
      params: {
        uri: "start_full.js"
      }
    },
    {
      method: "script.stop",
      params: {
        uri: "start_lite.js"
      }
    },
    {
      method: "shell.run",
      params: {
        message: "call install.cmd"
      }
    }
  ]
};
