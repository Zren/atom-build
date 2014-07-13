module.exports = ->
  return [
    {
      command: 'py'
      args: ['-2', atom.workspace.getActiveEditor().getUri()]
    }
  ]
