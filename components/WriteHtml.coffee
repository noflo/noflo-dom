noflo = require 'noflo'

class WriteHtml extends noflo.Component
  description: 'Write HTML inside an existing element'
  constructor: ->
    @container = null
    @html = null

    @inPorts =
      html: new noflo.Port 'string'
      container: new noflo.Port 'object'
    @outPorts = {}

    @inPorts.html.on 'data', (data) =>
      @html = data
      do writeHtml if @container
    @inPorts.container.on 'data', (data) =>
      @container = data
      do @writeHtml if @html

  writeHtml: ->
    @container.innerHTML = @html
    @html = null

exports.getComponent = -> new WriteHtml
