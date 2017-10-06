noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Append elements as children of a parent element'
  c.inPorts.add 'parent',
    datatype: 'object'
  c.inPorts.add 'child',
    datatype: 'object'

  c.process (input, output) ->
    return unless input.hasData 'parent', 'child'
    [parent, child] = input.getData 'parent', 'child'
    parent.appendChild child
    output.done()
