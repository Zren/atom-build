BuildConfigView = null

buildConfigUri = 'atom://buildconfig'
buildPackageDir = atom.packages.getLoadedPackage('build').path
buildScriptsDir = buildPackageDir + '/build-scripts/'
userBuildScriptsDir = buildScriptsDir + 'user/'

module.exports =
  configDefaults:
    buildScripts:
      # Paths are relative to ./libs/models/builder.coffee
      grammar:
        source:
          'c++': buildScriptsDir + 'source.c++.coffee'
          coffee: buildScriptsDir + 'source.coffee.coffee'
          js: buildScriptsDir + 'source.js.coffee'
          java: buildScriptsDir + 'source.java.coffee'
          python: buildScriptsDir + 'source.python.coffee'

  builder: null
  buildScriptsDir: buildScriptsDir
  userBuildScriptsDir: userBuildScriptsDir

  getBuildScriptPathByGrammarKey: (grammarScopeName) ->
    return 'build.buildScripts.grammar.' + grammarScopeName

  getDefaultBuildScriptPathByGrammar: (grammarScopeName) ->
    key = @getBuildScriptPathByGrammarKey(grammarScopeName)
    return atom.config.getDefault key

  getBuildScriptPathByGrammar: (grammarScopeName) ->
    key = @getBuildScriptPathByGrammarKey(grammarScopeName)
    return atom.config.get key

  setBuildScriptPathByGrammar: (grammarScopeName, buildScriptPath) ->
    key = @getBuildScriptPathByGrammarKey(grammarScopeName)
    atom.config.set key, buildScriptPath

  activate: (state) ->
    Builder = require './models/builder'
    @builder = new Builder()
    @registerCommands()
    atom.workspace.registerOpener (uri) =>
      @createBuildConfigView({uri}) if uri is buildConfigUri

    atom.workspaceView.on 'pane-container:active-pane-item-changed', ->
      if @buildConfigView is atom.workspace.getActivePaneItem()
        @buildConfigView?.redrawEditors()

  deactivate: ->
    @builder.destroy()
    @builder = null

  registerCommands: ->
    atom.workspaceView.command 'build:run', => @builder?.build()
    atom.workspaceView.command 'build:stop', => @builder?.stop()
    atom.workspaceView.command 'build:config', => atom.workspaceView.open(buildConfigUri)

  createBuildConfigView: (params) ->
    BuildConfigView ?= require './views/build-config-view'
    @buildConfigView = new BuildConfigView(params)
