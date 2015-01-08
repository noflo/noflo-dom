SetAttribute = require 'noflo-dom/components/SetAttribute.js'
socket = require('noflo').internalSocket

describe 'SetAttribute component', ->
  c = null
  element = null
  attribute = null
  value = null
  out = null
  el = document.querySelector '#fixtures .setattribute'
  beforeEach ->
    c = SetAttribute.getComponent()
    element = socket.createSocket()
    attribute = socket.createSocket()
    value = socket.createSocket()
    out = socket.createSocket()
    c.inPorts.element.attach element
    c.inPorts.attribute.attach attribute
    c.inPorts.value.attach value
    c.outPorts.element.attach out

  describe 'when called', ->
    it 'should return element', (done) ->
      out.on 'data', (data) ->
        chai.expect(data).to.equal el
        done()
      element.send el
      attribute.send 'foo'
      value.send 'baz'
  describe 'with matching query', ->
    it 'should update attribute', (done) ->
      out.on 'data', (data) ->
        content = el.getAttribute 'foo'
        chai.expect(content).to.equal 'baz'
        done()
      element.send el
      attribute.send 'foo'
      value.send 'baz'
  describe 'with non-matching query', ->
    it 'should create attribute', (done) ->
      out.on 'data', (data) ->
        content = el.getAttribute 'bar'
        chai.expect(content).to.equal 'baz'
        done()
      element.send el
      attribute.send 'bar'
      value.send 'baz'

