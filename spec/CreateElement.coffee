noflo = require 'noflo'
baseDir = 'noflo-dom'

describe 'CreateElement component', ->
  c = null
  tagname = null
  element = null
  before (done) ->
    loader = new noflo.ComponentLoader baseDir
    loader.load 'dom/CreateElement', (err, instance) ->
      return done err if err
      c = instance
      tagname = noflo.internalSocket.createSocket()
      element = noflo.internalSocket.createSocket()
      c.inPorts.tagname.attach tagname
      c.outPorts.element.attach element
      done()

  describe 'creating an Element', ->
    it 'should produce a new element', (done) ->
      element.on 'data', (data) ->
        chai.expect(data).to.be.instanceof HTMLElement
        done()
      tagname.send 'div'
