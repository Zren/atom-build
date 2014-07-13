module.exports = ->
  return [
    {
      command: 'node'
      args: [process.env.APPDATA + '\\npm\\node_modules\\coffee-script\\bin\\coffee', atom.workspace.getActiveEditor().getUri()]
    }
  ]
