noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Read HTML from an existing element'
  c.inPorts.add 'container',
    datatype: 'object'
  c.outPorts.add 'html',
    datatype: 'string'
  c.forwardBrackets =
    container: ['html']
  c.process (input, output) ->
    return unless input.hasData 'container'
    container = input.getData 'container'
    output.sendDone
      html: container.innerHTML
