{Emitter} = require atom.packages.resourcePath + '/node_modules/emissary'
Build = require './build'

class Builder
  Emitter.includeInto(this)

  gammarScopeNameBuildScripts:
    'source.coffee': '../../build-scripts/coffeescript.coffee'
    'source.js': '../../build-scripts/nodejs.coffee'

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
    scopeName = grammar.scopeName
    console.log scopeName

    buildScriptPath = @gammarScopeNameBuildScripts[scopeName]
    return unless buildScriptPath
    console.log buildScriptPath

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
