noflo = require 'noflo'

class SetAttribute extends noflo.Component
  constructor: ->
    @attribute = null
    @value = null
    @element = null

    @inPorts =
      element: new noflo.Port 'object'
      attribute: new noflo.Port 'string'
      value: new noflo.Port 'string'
    @outPorts =
      element: new noflo.Port 'object'

    @inPorts.element.on 'data', (@element) =>
      do @setAttribute if @attribute and @value
    @inPorts.attribute.on 'data', (@attribute) =>
      do @setAttribute if @element and @value
    @inPorts.value.on 'data', (@value) =>
      do @setAttribute if @attribute and @element

  setAttribute: ->
    @element.setAttribute @attribute, @value
    @value = null

    if @outPorts.element.isAttached()
      @outPorts.element.send @element
      @outPorts.element.disconnect()

exports.getComponent = -> new SetAttribute
