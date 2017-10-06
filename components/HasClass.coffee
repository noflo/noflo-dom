noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Check if an element has a given class'
  c.inPorts.add 'element',
    datatype: 'object'
  c.inPorts.add 'class',
    datatype: 'string'
  c.outPorts.add 'element',
    datatype: 'object'
  c.outPorts.add 'missed',
    datatype: 'object'
  c.process (input, output) ->
    return unless input.hasData 'element', 'class'
    [element, klass] = input.getData 'element', 'class'
    if element.classList.contains klass
      output.sendDone
        element: element
      return
    output.sendDone
      missed: element
