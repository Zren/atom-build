module.exports = ->
  return [
    {
      command: 'node'
      args: [atom.workspace.getActiveEditor().getUri()]
    }
  ]
