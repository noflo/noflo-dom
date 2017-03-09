noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c. description = 'Create a new DOM DocumentFragment'
  c.inPorts.add 'in',
    datatype: 'bang'
  c.outPorts.add 'fragment',
    datatype: 'object'

  c.forwardBrackets =
    in: ['fragment']

  c.process (input, output) ->
    return unless input.hasData 'in'
    input.getData 'in'
    fragment = document.createDocumentFragment()
    output.sendDone
      fragment: fragment
