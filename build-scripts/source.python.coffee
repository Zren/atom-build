module.exports = ->
  return [
    {
      command: 'python'
      args: [atom.workspace.getActiveEditor().getUri()]
    }
  ]
