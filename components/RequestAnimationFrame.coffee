noflo = require 'noflo'

# @runtime noflo-browser

requestAnimationFrame =
  window.requestAnimationFrame       ||
  window.webkitRequestAnimationFrame ||
  window.mozRequestAnimationFrame    ||
  window.oRequestAnimationFrame      ||
  window.msRequestAnimationFrame     ||
  (callback, element) ->
    window.setTimeout( ->
      callback(+new Date())
    , 1000 / 60)

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Sends bangs that correspond with screen refresh rate.'
  c.icon = 'film'

  c.inPorts.add 'start',
    datatype: 'bang'
  c.inPorts.add 'stop',
    datatype: 'bang'
  c.outPorts.add 'out',
    datatype: 'bang'

  c.running = {}
  cleanUp = (scope) ->
    return unless c.running[scope]
    c.running[scope].deactivate()
    delete c.running[scope]
  c.tearDown = (callback) ->
    for scope, running of c.running
      cleanUp scope
    c.running = {}
    callback()
  c.animate = (scope, output) ->
    # Stop when context has been stopped
    return unless c.running[scope]
    # Send bang
    output.send true
    # Request next frame
    requestAnimationFrame c.animate.bind c, scope, output

  c.forwardBrackets = {}
  c.process (input, output, context) ->
    if input.hasData 'start'
      start = input.get 'start'
      return unless start.type is 'data'
      # Ensure previous was deactivated
      cleanUp start.scope

      # Register scope
      c.running[start.scope] = context

      # Request first frame
      requestAnimationFrame c.animate.bind c, start.scope, output
      return

    if input.hasData 'stop'
      stop = input.get 'stop'
      return unless stop.type is 'data'
      # Deactivate this scope
      cleanUp stop.scope
      return
