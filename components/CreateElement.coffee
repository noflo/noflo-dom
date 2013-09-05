noflo = require 'noflo'

class CreateElement extends noflo.Component
  description: 'Create a new DOM Element'
  constructor: ->
    @inPorts =
      tagname: new noflo.Port 'string'
    @outPorts =
      element: new noflo.Port 'object'

    @inPorts.tagname.on 'data', (data) =>
      @outPorts.element.send document.createElement data
    @inPorts.tagname.on 'disconnect', =>
      @outPorts.element.disconnect()

exports.getComponent = -> new CreateElement
