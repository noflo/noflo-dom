noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Create a new DOM Element'
  c.inPorts.add 'tagname',
    datatype: 'string'
  c.inPorts.add 'container',
    datatype: 'object'
  c.outPorts.add 'element',
    datatype: 'object'
  c.forwardBrackets =
    tagname: ['element']

  c.process (input, output) ->
    return unless input.hasData 'tagname'
    if c.inPorts.container.isAttached()
      # If container is attached, we want it too
      return unless input.hasData 'container'

    tagname = input.getData 'tagname'
    element = document.createElement tagname
    if input.hasData 'container'
      container = input.getData 'container'
      container.appendChild element

    output.sendDone
      element: element
