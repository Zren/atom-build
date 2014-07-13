{$, $$, ScrollView, EditorView, View} = require 'atom'
PageView = require './page-view'
fs = require 'fs'

buildModule = require '../main'
{buildScriptsDir, userBuildScriptsDir} = buildModule

class GrammarsPanel extends ScrollView
  @content: (params) ->
    @div =>
      @h1 class: 'block section-heading', =>
        @text 'Build Scripts '
        @small 'by Grammar'
      @p =>
        @text 'Scripts are javasciprt or coffeescript modules. '
        @code 'module.exports'
        @text ' should contain a function that returns an array of '
        @code '{command: "node", args: [atom.workspace.getActiveView().getUri()]}'
      @p =>
        @text 'Press Edit next to any input field to generate a new script in '
        @code userBuildScriptsDir
        @text '.'
      @div class: 'container-fluid', outlet: 'grammarSection'

  initialize: ->
    super
    @populate()

    @find('.grammar').each ->
      grammarElement = $(@)
      grammarElement.find('.build-script-path').on 'change', ->
        grammarScopeName = grammarElement.data('scope-name')
        grammarBuildScriptPath = @.value
        if grammarBuildScriptPath
          grammarBuildScriptPath = require('path').resolve(grammarBuildScriptPath)
          @.value = grammarBuildScriptPath
        buildModule.setBuildScriptPathByGrammar(grammarScopeName, grammarBuildScriptPath)

      grammarElement.find('.edit-btn').on 'click', ->
        buildScriptPathElement = grammarElement.find('.build-script-path')
        buildScriptPath = buildScriptPathElement[0].value
        newScript = false
        unless buildScriptPath
          newScript = true
          grammarScopeName = grammarElement.data('scope-name')
          buildScriptPath = userBuildScriptsDir + grammarScopeName + '.coffee'
          buildScriptPathElement.attr('value', buildScriptPath).trigger('change')
        atom.workspaceView.open(buildScriptPath).done (editor) ->
          if newScript
            templateBuildScriptPath = buildScriptsDir + '/_template.coffee'
            fs.readFile templateBuildScriptPath, (err, data) ->
              unless err
                editor.setText(data.toString())

  populate: ->
    grammars = atom.syntax.getGrammars()
    grammars.sort (a, b) ->
      a?.name - b?.name

    console.log @grammarSection
    appendGrammars.call @grammarSection, grammars

appendGrammars = (grammars) ->
  return unless grammars.length

  @append $$ ->
    for grammar in grammars
      appendGrammar.call this, grammar

appendGrammar = (grammar) ->
  grammarBuildScriptPath = buildModule.getBuildScriptPathByGrammar(grammar.scopeName)
  grammarBuildScriptPath ?= ''
  defaultGrammarBuildScriptPath = buildModule.getDefaultBuildScriptPathByGrammar(grammar.scopeName)
  defaultGrammarBuildScriptPath ?= ''
  if grammarBuildScriptPath is defaultGrammarBuildScriptPath
    grammarBuildScriptPath = ''

  @div class: 'grammar row form-horizontal', 'data-scope-name': grammar.scopeName, =>
    @label class: 'col-xs-3 control-label', grammar.name
    @div class: 'col-xs-9', =>
      @div class: 'input-group', =>

        @input class: 'form-control build-script-path', type: 'text', value: grammarBuildScriptPath, placeholder: defaultGrammarBuildScriptPath
        @div class: 'input-group-btn', =>
          @button class: 'btn btn-primary icon icon-file edit-btn', type: 'button', 'Edit'


class BuilderConfigView extends PageView
  initialize: ({@uri, activePanelName}={}) ->
    super
    @title = 'Build Config'
    @iconName = 'tools'

    @addClass 'build-config-view'


  initializePanels: ->
    super

    @addPanel 'Grammars', => new GrammarsPanel

    @showPanel(@panelToShow) if @panelToShow
    @showPanel('Grammars') unless @activePanelName

module.exports = BuilderConfigView
