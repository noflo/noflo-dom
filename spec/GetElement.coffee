noflo = require 'noflo'
baseDir = 'noflo-dom'

describe 'GetElement component', ->
  c = null
  ins = null
  selector = null
  element = null
  error = null
  before (done) ->
    loader = new noflo.ComponentLoader baseDir
    loader.load 'dom/GetElement', (err, instance) ->
      return done err if err
      c = instance
      selector = noflo.internalSocket.createSocket()
      c.inPorts.selector.attach selector
      done()
  beforeEach ->
    element = noflo.internalSocket.createSocket()
    c.outPorts.element.attach element
    error = noflo.internalSocket.createSocket()
    c.outPorts.error.attach error
  afterEach ->
    c.outPorts.element.detach element
    element = null
    c.outPorts.error.detach error
    error = null

  describe 'with non-matching query', ->
    it 'should transmit an Error when ERROR port is attached', (done) ->
      error.on 'data', (data) ->
        chai.expect(data).to.be.an.instanceof Error
        done()
      selector.send 'Foo'

  describe 'with invalid query', ->
    before ->
      ins = noflo.internalSocket.createSocket()
      c.inPorts.in.attach ins
    after ->
      c.inPorts.in.detach ins
    it 'should transmit an Error when ERROR port is attached', (done) ->
      error.on 'data', (data) ->
        chai.expect(data).to.be.an.instanceof Error
        done()
      selector.send 'baz'
      ins.send {}

  describe 'with invalid container', ->
    before ->
      ins = noflo.internalSocket.createSocket()
      c.inPorts.in.attach ins
    after ->
      c.inPorts.in.detach ins
    it 'should transmit an Error when ERROR port is attached', (done) ->
      error.on 'data', (data) ->
        chai.expect(data).to.be.an.instanceof Error
        done()
      selector.send 'baz'
      ins.send {}

  describe 'with matching query without container', ->
    it 'should send the matched element to the ELEMENT port', (done) ->
      query = '#fixtures .getelement'
      el = document.querySelector query
      error.on 'data', (data) ->
        done data
      element.on 'data', (data) ->
        chai.expect(data.tagName).to.exist
        chai.expect(data.tagName).to.equal 'DIV'
        chai.expect(data.innerHTML).to.equal 'Foo'
        chai.expect(data).to.equal el
        done()
      selector.send query

  describe 'with matching query with container', ->
    before ->
      ins = noflo.internalSocket.createSocket()
      c.inPorts.in.attach ins
    after ->
      c.inPorts.in.detach ins
    it 'should send the matched element to the ELEMENT port', (done) ->
      container = document.querySelector '#fixtures'
      el = document.querySelector '#fixtures .getelement'
      error.on 'data', (data) ->
        done data
      element.on 'data', (data) ->
        chai.expect(data.tagName).to.exist
        chai.expect(data.tagName).to.equal 'DIV'
        chai.expect(data.innerHTML).to.equal 'Foo'
        chai.expect(data).to.equal el
        done()
      ins.send container
      selector.send '.getelement'
