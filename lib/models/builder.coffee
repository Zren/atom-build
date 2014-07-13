{Emitter} = require atom.packages.resourcePath + '/node_modules/emissary'
Build = require './build'

buildModule = require '../main'

class Builder
  Emitter.includeInto(this)

  build: ->
    console.log('Builder: build')
    @buildFile()

  # Build the current view by grammar
  buildFile: ->
    console.log('Builder: buildFile')

    # Kill any existing builds.
    @currentBuild?.kill()

    editor = atom.workspace.getActiveEditor()
    return unless editor

    grammar = editor.getGrammar()
    grammarScopeName = grammar.scopeName
    console.log grammarScopeName

    buildScriptPath = buildModule.getBuildScriptPathByGrammar(grammarScopeName)
    return unless buildScriptPath
    buildScriptPath = require('path').resolve(buildScriptPath)
    console.log buildScriptPath

    # Delete the script from the module cache.
    # This allows the user to edit the script without reloading Atom.
    delete require.cache[buildScriptPath]
    delete require('module')._cache[buildScriptPath]

    script = require buildScriptPath
    commands = script()

    @currentBuild = new Build()
    @currentBuild.commands = commands
    @currentBuild.run()

  stop: ->
    @currentBuild?.kill()

  destroy: ->
    @stop()


module.exports = Builder
