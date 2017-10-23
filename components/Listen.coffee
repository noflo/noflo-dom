noflo = require 'noflo'

# @runtime noflo-browser

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'addEventListener for specified event type'
  c.icon = 'stethoscope'

  c.inPorts.add 'element',
    datatype: 'object'
  c.inPorts.add 'type',
    datatype: 'string'
  c.inPorts.add 'preventdefault',
    datatype: 'boolean'
    control: true
    default: false
  c.outPorts.add 'element',
    datatype: 'object'
  c.outPorts.add 'event',
    datatype: 'object'

  c.elements = {}
  cleanUp = (scope) ->
    return unless c.elements[scope]
    {element, event, listener} = c.elements[scope]
    element.removeEventListener event, listener
    c.elements[scope].deactivate()
    delete c.elements[scope]
  c.tearDown = (callback) ->
    for scope, element of c.elements
      cleanUp scope
    c.elements = {}
    callback()
  c.forwardBrackets = {}

  c.process (input, output, context) ->

    return unless input.hasData 'element', 'type'
    [element, type] = input.getData 'element', 'type'

    preventDefault = false
    if input.hasData 'preventdefault'
      preventDefault = input.getData 'preventdefault'

    scope = null
    cleanUp scope

    context.element = element
    context.event = type
    context.listener = (event) ->
      event.preventDefault() if preventDefault
      output.send
        element: context.element
        event: event
    c.elements[context] = context
    element.addEventListener type, context.listener
