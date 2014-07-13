{$, $$, ScrollView, EditorView, View} = require 'atom'
PageView = require './page-view'
fs = require 'fs'

class GrammarsPanel extends ScrollView
  @content: (params) ->
    @div =>
      @h1 class: 'block section-heading icon icon-gear', 'Grammars'
      @div class: 'container', outlet: 'grammarSection'

  initialize: ->
    super
    @populate()

    @find('.grammar').each ->
      $(@).find('.edit-btn').on 'click', =>
        grammarScopeName = $(@).data('scope-name')
        buildPackage = atom.packages.getActivePackage('build')
        buildScriptPath = buildPackage.path + '/build-scripts/' + grammarScopeName + '.coffee'
        $(@).find('.build-script-path').attr('value', buildScriptPath)
        atom.workspaceView.open(buildScriptPath).done (editor) ->
          buildPackage = atom.packages.getActivePackage('build')
          templateBuildScriptPath = buildPackage.path + '/build-scripts/_template.coffee'
          fs.readFile templateBuildScriptPath, (err, data) ->
            console.log err, data
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
  buildModule = atom.packages.getActivePackage('build')?.mainModule
  builder = buildModule?.builder
  grammarBuildScriptPath = builder?.gammarScopeNameBuildScripts[grammar.scopeName]
  grammarBuildScriptPath ?= ''
  # console.log grammar.name, grammarBuildScriptPath

  @div class: 'grammar row form-horizontal', 'data-scope-name': grammar.scopeName, =>
    @label class: 'col-xs-3 control-label', grammar.name
    @div class: 'col-xs-9', =>
      @div class: 'input-group', =>
        @input class: 'form-control build-script-path', type: 'text', value: grammarBuildScriptPath
        @div class: 'input-group-btn', =>
          @button class: 'btn btn-default icon icon-file edit-btn', type: 'button', 'Edit'


class BuilderConfigView extends PageView
  initialize: ({@uri, activePanelName}={}) ->
    super
    @title = 'Build Config'
    @iconName = 'tools'

    @addClass 'settings-view'


  initializePanels: ->
    super

    @addPanel 'Grammars', => new GrammarsPanel

    @showPanel(@panelToShow) if @panelToShow
    @showPanel('Grammars') unless @activePanelName

module.exports = BuilderConfigView
