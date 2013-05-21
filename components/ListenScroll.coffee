noflo = require 'noflo'

class ListenScroll extends noflo.Component
  description: 'Listen to scroll events'
  constructor: ->
    @inPorts =
      start: new noflo.Port
    @outPorts =
      top: new noflo.ArrayPort 'number'
      bottom: new noflo.ArrayPort 'number'
      left: new noflo.ArrayPort 'number'
      right: new noflo.ArrayPort 'number'

    @inPorts.start.on 'data', =>
      @subscribe()

  subscribe: ->
    window.addEventListener 'scroll', @scroll, false

  scroll: (event) =>
    top = window.scrollY
    bottom = top + window.innerHeight
    left = window.scrollX
    right = left + window.innerWidth
    @outPorts.top.send top
    @outPorts.top.disconnect()
    @outPorts.bottom.send bottom
    @outPorts.bottom.disconnect()
    @outPorts.left.send left
    @outPorts.left.disconnect()
    @outPorts.right.send right
    @outPorts.right.disconnect()

exports.getComponent = -> new ListenScroll
