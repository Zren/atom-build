{BufferedProcess} = require 'atom'
StatusView = require './views/status-view'

# Based on the git-plus Atom package

# Returns the root directory for a git repo,
#   submodule first if currently in one or the project root
dir = ->
  if submodule = getSubmodule()
    submodule.getWorkingDirectory()
  else
    atom.project.getRepo()?.getWorkingDirectory() ? atom.project.getPath()

# returns submodule for given file or undefined
getSubmodule = (path) ->
  path ?= atom.workspace.getActiveEditor()?.getPath()
  atom.project.getRepo()?.repo.submoduleForPath(path)

# Public: Execute a git command.
#
# options - An {Object} with the following keys:
#   :args    - The {Array} containing the arguments to pass.
#   :options - The {Object} with options to pass.
#     :cwd  - Current working directory as {String}.
#   :stdout  - The {Function} to pass the stdout to.
#   :exit    - The {Function} to pass the exit code to.
#
# Returns nothing.
command = ({command, args, options, stdout, stderr, exit}={}) ->
  options ?= {}
  options.cwd ?= dir()
  options.stdio ?= ['ignore', 'pipe', 'pipe']

  stderr ?= (data) -> new StatusView(type: 'alert', message: data.toString())

  new BufferedProcess
    command: command
    args: args
    options: options
    stdout: stdout
    stderr: stderr
    exit: exit

module.exports = command
