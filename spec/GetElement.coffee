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
      ins = noflo.internalSocket.createSocket()
      selector = noflo.internalSocket.createSocket()
      c.inPorts.in.attach ins
      c.inPorts.selector.attach selector
      done()
  beforeEach ->
    element = noflo.internalSocket.createSocket()
    c.outPorts.element.attach element
    error = noflo.internalSocket.createSocket()
  afterEach ->
    c.outPorts.element.detach element
    element = null
    c.outPorts.error.detach error
    error = null

  describe 'with non-matching query', ->
    it 'should throw an error when ERROR port is not attached', ->
      chai.expect(-> selector.send 'Foo').to.throw Error
    it 'should transmit an Error when ERROR port is attached', (done) ->
      error.on 'data', (data) ->
        chai.expect(data).to.be.an.instanceof Error
        done()
      c.outPorts.error.attach error
      selector.send 'Foo'

  describe 'with invalid query', ->
    it 'should throw an error when ERROR port is not attached', ->
      chai.expect(-> ins.send {}).to.throw Error
    it 'should transmit an Error when ERROR port is attached', (done) ->
      error.on 'data', (data) ->
        chai.expect(data).to.be.an.instanceof Error
        done()
      c.outPorts.error.attach error
      ins.send {}

  describe 'with invalid container', ->
    it 'should throw an error when ERROR port is not attached', ->
      chai.expect(-> ins.send {}).to.throw Error
    it 'should transmit an Error when ERROR port is attached', (done) ->
      error.on 'data', (data) ->
        chai.expect(data).to.be.an.instanceof Error
        done()
      c.outPorts.error.attach error
      ins.send {}

  describe 'with matching query without container', ->
    it 'should send the matched element to the ELEMENT port', (done) ->
      query = '#fixtures .getelement'
      el = document.querySelector query
      element.on 'data', (data) ->
        chai.expect(data.tagName).to.exist
        chai.expect(data.tagName).to.equal 'DIV'
        chai.expect(data.innerHTML).to.equal 'Foo'
        chai.expect(data).to.equal el
        done()
      selector.send query

  describe 'with matching query with container', ->
    it 'should send the matched element to the ELEMENT port', (done) ->
      container = document.querySelector '#fixtures'
      el = document.querySelector '#fixtures .getelement'
      element.on 'data', (data) ->
        chai.expect(data.tagName).to.exist
        chai.expect(data.tagName).to.equal 'DIV'
        chai.expect(data.innerHTML).to.equal 'Foo'
        chai.expect(data).to.equal el
        done()
      ins.send container
      selector.send '.getelement'
