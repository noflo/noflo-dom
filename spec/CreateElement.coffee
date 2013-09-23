CreateElement = require 'noflo-dom/components/CreateElement.js'
socket = require('noflo').internalSocket

describe 'CreateElement component', ->
  c = null
  tagname = null
  element = null
  beforeEach ->
    c = CreateElement.getComponent()
    tagname = socket.createSocket()
    element = socket.createSocket()
    c.inPorts.tagname.attach tagname
    c.outPorts.element.attach element

  describe 'creating an Element', ->
    it 'should produce a new element', (done) ->
      element.on 'data', (data) ->
        chai.expect(data).to.be.instanceof HTMLElement
        done()
      tagname.send 'div'
