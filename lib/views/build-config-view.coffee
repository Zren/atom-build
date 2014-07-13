{$, $$, ScrollView, EditorView, View} = require 'atom'
PageView = require './page-view'

class GrammarsPanel extends ScrollView
  @content: (params) ->
    @div =>
      @h1 class: 'block section-heading icon icon-gear', 'Grammars'
      @div class: 'container', outlet: 'grammarSection'

  initialize: ->
    super
    @populate()

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
  buildScriptPath = builder?.gammarScopeNameBuildScripts[grammar.scopeName]
  buildScriptPath ?= ''
  # console.log grammar.name, buildScriptPath

  @div class: 'row form-horizontal', =>
    @label class: 'col-xs-3 control-label', grammar.name
    @div class: 'col-xs-9', =>
      @div class: 'input-group', =>
        @input class: 'form-control', type: 'text', value: buildScriptPath
        @div class: 'input-group-btn', =>
          @button class: 'btn btn-default icon icon-file', type: 'button', 'Edit'


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
