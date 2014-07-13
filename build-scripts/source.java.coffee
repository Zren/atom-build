module.exports = ->
  path = require 'path'
  uri = atom.workspace.getActiveEditor().getUri()
  cwd = path.dirname(uri)
  basename = path.basename(uri)
  classname = basename.substring(0, basename.length - '.java'.length)
  return [
    {
      command: 'javac'
      args: [basename]
      options:
        cwd: cwd
    }
    {
      command: 'java'
      args: [classname]
      options:
        cwd: cwd
    }
  ]
