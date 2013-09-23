noflo = require 'noflo'

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

class RequestAnimationFrame extends noflo.Component
  description: 'Sends bangs that correspond with screen refresh rate.'

  constructor: ->
    @running = false

    @inPorts =
      start: new noflo.Port 'bang'
      stop: new noflo.Port 'bang'
    @outPorts =
      frame: new noflo.Port 'bang'

    @inPorts.start.on 'data', (data) =>
      @animate
      @running = true

    @inPorts.stop.on 'data', (data) =>
      @running = false

  animate: ->
    if @running
      requestAnimationFrame @animate
      @outPorts.frame.send true

exports.getComponent = -> new RequestAnimationFrame
