GetAttribute = require 'noflo-dom/components/GetAttribute.js'
socket = require('noflo').internalSocket

describe 'GetAttribute component', ->
  c = null
  element = null
  attribute = null
  out = null
  el = document.querySelector '#fixtures .getattribute'
  beforeEach ->
    c = GetAttribute.getComponent()
    element = socket.createSocket()
    attribute = socket.createSocket()
    out = socket.createSocket()
    c.inPorts.element.attach element
    c.inPorts.attribute.attach attribute
    c.outPorts.out.attach out

  describe 'with matching query', ->
    it 'should return value', (done) ->
      out.on 'data', (data) ->
        chai.expect(data).to.equal 'bar'
        done()
      element.send el
      attribute.send 'foo'
  describe 'with non-matching query', ->
    it 'should return a NULL', (done) ->
      out.on 'data', (data) ->
        chai.expect(data).to.be.a 'null'
        done()
      element.send el
      attribute.send 'bar'
