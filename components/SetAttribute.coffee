'use strict'

# @runtime noflo-browser

noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  c.description = "Set the given attribute on the DOM element to the received
    value."
    
  # Define in ports.
  c.inPorts.add 'element',
    datatype: 'object'
    description: 'The element on which to set the attribute.'

  c.inPorts.add 'attribute',
    datatype: 'string'
    description: 'The attribute which is set on the DOM element.'

  c.inPorts.add 'value',
    datatype: 'string'
    description: 'Value of the attribute being set.'
  
  # Define out ports.
  c.outPorts.add 'element',
    datatype: 'object'
    description: 'The element that was updated.'

  c.forwardBrackets =
    element: ['element']
    value: ['element']

  c.process (input, output) ->
    return unless input.hasData 'element', 'attribute', 'value'
    [element, attribute, value] = input.getData 'element', 'attribute', 'value'
    if typeof value is 'object'
      if toString.call(value) is '[object Array]'
        value = value.join ' '
      else
        newVal = []
        newVal.push val for key, val of value
        value = newVal.join ' '
    if attribute is "value"
      element.value = value
    else
      element.setAttribute attribute, value

    output.sendDone
      element: element
