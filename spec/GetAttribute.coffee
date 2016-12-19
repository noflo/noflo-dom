noflo = require 'noflo'
baseDir = 'noflo-dom'

describe 'GetAttribute component', ->
  c = null
  element = null
  attribute = null
  out = null
  el = document.querySelector '#fixtures .getattribute'
  before (done) ->
    loader = new noflo.ComponentLoader baseDir
    loader.load 'dom/GetAttribute', (err, instance) ->
      return done err if err
      c = instance
      element = noflo.internalSocket.createSocket()
      attribute = noflo.internalSocket.createSocket()
      c.inPorts.element.attach element
      c.inPorts.attribute.attach attribute
      done()
  beforeEach ->
    out = noflo.internalSocket.createSocket()
    c.outPorts.out.attach out
  afterEach ->
    c.outPorts.out.detach out
    out = null

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
      attribute.send 'bar'
      element.send el
