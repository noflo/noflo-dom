noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Remove a class from an element'
  c.inPorts.add 'element',
    datatype: 'object'
  c.inPorts.add 'class',
    datatype: 'string'

  c.process (input, output) ->
    return unless input.has 'element', 'class'
    [element, className] = input.getData 'element', 'class'
    element.classList.remove className
    output.done()
