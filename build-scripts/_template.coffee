module.exports = ->
  path = require 'path'
  uri = atom.workspace.getActiveEditor().getUri()

  # SublimeText variables
  file = uri
  file_name = path.basename(uri)
  file_path = path.dirname(uri)
  file_extension = path.extname(file_name)
  file_base_name = file_name.substring(0, file_name.length - file_extension.length)
  file_extension = file_extension?.substring(1)

  return [
    {
      command: 'node'
      args: [file]
    }
  ]
