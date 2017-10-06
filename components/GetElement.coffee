noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description ='Get a DOM element matching a query'
  c.inPorts.add 'in',
    datatype: 'object'
    description: 'DOM element to constrain the query to'
  c.inPorts.add 'selector',
    datatype: 'string'
    description: 'CSS selector'
  c.outPorts.add 'element',
    datatype: 'object'
  c.outPorts.add 'error',
    datatype: 'object'
  c.forwardBrackets =
    selector: ['element', 'error']
  c.process (input, output) ->
    return unless input.hasData 'selector'
    return unless input.hasData 'in' if input.attached('in').length > 0
    if input.hasData 'in'
      # Element-scoped selector
      [container, selector] = input.getData 'in', 'selector'
      unless typeof container.querySelector is 'function'
        output.done new Error 'Given container doesn\'t support querySelectors'
        return
      el = container.querySelectorAll selector
      unless el.length
        output.done new Error "No element matching '#{selector}' found under container"
        return
      for element in el
        output.send
          element: element
      output.done()
      return
    selector = input.getData 'selector'
    el = document.querySelectorAll selector
    unless el.length
      output.done new Error "No element matching '#{selector}' found under document"
      return
    for element in el
      output.send
        element: element
    output.done()
