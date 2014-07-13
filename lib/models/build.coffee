{Emitter} = require atom.packages.resourcePath + '/node_modules/emissary'
consoleCommand = require '../console-command'
OutputView = require '../views/output-view'

class Build
  Emitter.includeInto(this)

  constructor: (@name) ->
    @commands = []
    @currentCommandIndex = -1
    @killed = false

  nextCommand: ->
    console.log('Build: nextCommand')
    @currentCommandIndex += 1
    @currentCommand = @commands[@currentCommandIndex]
    console.log('Build: currentCommandIndex', @currentCommandIndex)

  run: ->
    console.log('Build: run')
    return unless @commands.length
    console.log('Build: commands: ', @commands)
    @view = new OutputView()
    @nextCommand()
    @runCurrentCommand()

  runCurrentCommand: ->
    console.log('Build: runCurrentCommand')
    console.log('Build: currentCommand: ', @currentCommand)
    @output(@currentCommand.command + ' ' + @currentCommand.args + '\n')
    @currentProccess = consoleCommand
      command: @currentCommand.command
      args: @currentCommand.args
      stdout: (data) =>
        if data
          console.log('Build: stdout: ', data)
          @output(data.toString())
      stderr: (data) =>
        if data
          console.log('Build: stderr: ', data)
          @output(data.toString())
      exit: (code) => @commandDone(code)

  output: (msg) ->
    @view.addLine(msg)

  commandDone: (code) ->
    console.log('Build: commandDone(#{code}): ', @currentCommand)
    @currentProccess = null
    @nextCommand()
    if @currentCommandIndex >= @commands.length or @killed
      @finish()
    else
      @runCurrentCommand()

  finish: ->
    console.log('Build: finish')
    @view.finish()

  kill: ->
    @killed = true
    @currentProccess?.kill()

module.exports = Build
