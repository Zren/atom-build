{$, $$, ScrollView} = require 'atom'

class PageView extends ScrollView
  @content: ->
    @div class: 'pane-item', tabindex: -1, =>
       @div class: 'panels padded', outlet: 'panels'

  initialize: ({@uri, activePanelName}={}) ->
    super
    console.log 'PageView: initialize'

    @panelToShow = activePanelName
    process.nextTick => @initializePanels()

  initializePanels: ->
    console.log 'PageView: initializePanels'
    return if @panels.size > 0

    @panelsByName = {}
    @on 'click', 'a.show-panel', (e) =>
      @showPanel($(e.target).data('panel-name'))

  redrawEditors: ->
    $(element).view().redraw() for element in @find('.editor')

  getOrCreatePanel: (name) ->
    console.log 'PageView: getOrCreatePanel', name
    panel = @panelsByName?[name]
    unless panel?
      if callback = @panelCreateCallbacks?[name]
        panel = callback()
        @panelsByName ?= {}
        @panelsByName[name] = panel
        delete @panelCreateCallbacks[name]
    panel

  focus: ->
    super

    # Pass focus to panel that is currently visible
    for panel in @panels.children()
      child = $(panel)
      if child.isVisible()
        if view = child.view()
          view.focus()
        else
          child.focus()
        return

  showPanel: (name) ->
    console.log 'PageView: showPanel', name
    if panel = @getOrCreatePanel(name)
      @panels.children().hide()
      @panels.append(panel) unless $.contains(@panels[0], panel[0])
      panel.show()
      for editorElement, index in panel.find(".editor")
        $(editorElement).view().redraw()
      panel.focus()
      @activePanelName = name
      @panelToShow = null
    else
      @panelToShow = name

  addPanel: (name, panelCreateCallback) ->
    console.log 'PageView: addPanel', name
    @panelCreateCallbacks ?= {}
    @panelCreateCallbacks[name] = panelCreateCallback
    @showPanel(name) if @panelToShow is name

  removePanel: (name) ->
    if panel = @panelsByName?[name]
      panel.remove()
      delete @panelsByName[name]
    @panelPackages.find("li[name=\"#{name}\"]").remove()

  getTitle: ->
    @title

  getIconName: ->
    @iconName

  getUri: ->
    @uri

  isEqual: (other) ->
    other instanceof PageView and @getUri() == other.getUri()

module.exports = PageView
