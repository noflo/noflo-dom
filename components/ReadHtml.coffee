noflo = require 'noflo'

class ReadHtml extends noflo.Component
  description: 'Write HTML inside an existing element'
  constructor: ->
    @inPorts =
      container: new noflo.Port 'object'
    @outPorts =
      html: new noflo.Port 'string'

    @inPorts.container.on 'data', (data) =>
      @outPorts.html.send data.innerHTML
      @outPorts.html.disconnect()

exports.getComponent = new ReadHtml
