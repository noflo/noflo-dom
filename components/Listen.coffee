noflo = require 'noflo'

class Listen extends noflo.Component
  description: 'addEventListener for specified event type'
  icon: 'stethoscope'

  constructor: ->
    @element = null
    @type = null
    @preventDefault = false

    @inPorts =
      element: new noflo.Port 'object'
      type: new noflo.Port 'string'
      preventdefault: new noflo.Port 'boolean'
    @outPorts =
      element: new noflo.Port 'object'
      event: new noflo.Port 'object'

    @inPorts.element.on 'data', (data) =>
      if @element and @type
        @unsubscribe @element, @type

      @element = data

      if @type
        @subscribe @element, @type

    @inPorts.type.on 'data', (data) =>
      if @element and @type
        @unsubscribe @element, @type

      @type = data

      if @element
        @subscribe @element, @type

    @inPorts.preventdefault.on 'data', (data) =>
      @preventDefault = data

  unsubscribe: (element, type) ->
    element.removeEventListener type, @change

  subscribe: (element, type) ->
    element.addEventListener type, @change

  change: (event) =>
    if @preventDefault
      event.preventDefault()
    if @outPorts.element.isAttached()
      @outPorts.element.send @element
    if @outPorts.event.isAttached()
      @outPorts.event.send event

exports.getComponent = -> new Listen
