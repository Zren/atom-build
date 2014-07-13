{Subscriber} = require 'emissary'
{$, ScrollView} = require 'atom'

module.exports =
  class OutputView extends ScrollView
    Subscriber.includeInto (this)

    message: ''

    @content: ->
      @div class: 'info-view', =>
        @pre class: 'output', outlet: 'output'

    initialize: ->
      super
      atom.workspaceView.appendToBottom(this)
      @subscribe $(window), 'core:cancel', => @detach()

    addLine: (line) ->
      @message += line
      @output.text(line)
      @output[0].scrollTop = @output[0].scrollHeight


    reset: ->
      @message = ''

    finish: ->
      setTimeout =>
        @detach()
      , 10000

    detach: ->
      super
      @unsubscribe()
