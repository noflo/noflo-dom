noflo = require 'noflo'

# @runtime noflo-browser

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
    control: true

  # Define out ports.
  c.outPorts.add 'out',
    datatype: 'string'
    description: 'Value of the attribute being read.'

  c.forwardBrackets =
    element: ['out']

  # On data flow.
  c.process (input, output) ->
    return unless input.hasData 'element', 'attribute'
    [element, attribute] = input.getData 'element', 'attribute'
    value = element.getAttribute attribute
    output.sendDone
      out: value
