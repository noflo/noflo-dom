noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Write HTML inside an existing element'
  c.inPorts.add 'container',
    datatype: 'object'
  c.inPorts.add 'html',
    datatype: 'string'
  c.outPorts.add 'container',
    datatype: 'object'
  c.process (input, output) ->
    return unless input.hasData 'container', 'html'
    [container, html] = input.getData 'container', 'html'
    container.innerHTML = html
    output.sendDone
      container: container
