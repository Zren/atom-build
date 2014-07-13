BuildConfigView = null

buildConfigUri = 'atom://buildconfig'

module.exports =
  configDefaults:
    environment: ""
    arguments: ""

  builder: null

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
