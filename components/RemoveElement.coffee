noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Remove an element from DOM'
  c.inPorts.add 'element',
    datatype: 'object'
  c.process (input, output) ->
    return unless input.hasData 'element'
    element = input.getData 'element'
    return unless element.parentNode
    element.parentNode.removeChild element
    output.done()
