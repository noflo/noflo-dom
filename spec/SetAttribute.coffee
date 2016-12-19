noflo = require 'noflo'
baseDir = 'noflo-dom'

describe 'SetAttribute component', ->
  c = null
  element = null
  attribute = null
  value = null
  out = null
  el = document.querySelector '#fixtures .setattribute'
  before (done) ->
    loader = new noflo.ComponentLoader baseDir
    loader.load 'dom/SetAttribute', (err, instance) ->
      return done err if err
      c = instance
      element = noflo.internalSocket.createSocket()
      attribute = noflo.internalSocket.createSocket()
      value = noflo.internalSocket.createSocket()
      c.inPorts.element.attach element
      c.inPorts.attribute.attach attribute
      c.inPorts.value.attach value
      done()
  beforeEach ->
    out = noflo.internalSocket.createSocket()
    c.outPorts.element.attach out
  afterEach ->
    c.outPorts.element.detach out
    out = null

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

