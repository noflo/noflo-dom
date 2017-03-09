noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Add a class to an element'
  c.inPorts.add 'element',
    datatype: 'object'
  c.inPorts.add 'class',
    datatype: 'string'

  c.process (input, output) ->
    return unless input.has 'element', 'class'
    [element, className] = input.getData 'element', 'class'
    element.classList.add className
    output.done()
