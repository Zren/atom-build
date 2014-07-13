module.exports = ->
  return [
    {
      command: 'py'
      args: ['-3', atom.workspace.getActiveEditor().getUri()]
    }
  ]
