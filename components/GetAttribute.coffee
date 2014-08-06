'use strict'

noflo = require 'noflo'


exports.getComponent = ->
  c = new noflo.Component
  c.description = "Reads the given attribute from the DOM element on the in
    port."

  # Define in ports.
  c.inPorts.add 'element',
    datatype: 'object'
    description: 'The element from which to read the attribute from.'
    required: true

  c.inPorts.add 'attribute',
    datatype: 'string'
    description: 'The attribute which is read from the DOM element.'
    required: true

  # Define out ports.
  c.outPorts.add 'out',
    datatype: 'string'
    description: 'Value of the attribute being read.'

  # On data flow.
  noflo.helpers.WirePattern c,
    in: ['element']
    out: ['out']
    params: ['attribute']
    forwardGroups: true
  ,
    (data, groups, out) ->
      attr = c.params.attribute
      value = data.getAttribute attr

      out.send value
