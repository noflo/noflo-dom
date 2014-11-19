'use strict'

noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  c.description = "Set the given attribute on the DOM element to the received
    value."
    
  # Define in ports.
  c.inPorts.add 'element',
    datatype: 'object'
    description: 'The element on which to set the attribute.'
    required: true

  c.inPorts.add 'attribute',
    datatype: 'string'
    description: 'The attribute which is set on the DOM element.'
    required: true

  c.inPorts.add 'value',
    datatype: 'string'
    description: 'Value of the attribute being set.'
  
  # Define out ports.
  c.outPorts.add 'element',
    datatype: 'object'
    description: 'The element that was updated.'

  # On data flow.
  noflo.helpers.WirePattern c,
    in: ['element', 'value']
    out: ['element']
    params: ['attribute']
    forwardGroups: true
  ,
    (data, groups, out) ->
      attr = c.params.attribute
      value = data.value
      if typeof value is 'object'
        if toString.call(value) is '[object Array]'
          value = value.join ' '
        else
          newVal = []
          newVal.push val for key, val of value
          value = newVal.join ' '
      data.element.setAttribute attr, value

      out.send data.element
  
