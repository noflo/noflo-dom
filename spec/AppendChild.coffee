AppendChild = require 'noflo-dom/components/AppendChild.js'
socket = require('noflo').internalSocket

describe 'AppendChild component', ->
  c = null
  parent = null
  child = null
  beforeEach ->
    c = AppendChild.getComponent()
    parent = socket.createSocket()
    child = socket.createSocket()
    c.inPorts.parent.attach parent
    c.inPorts.child.attach child

  describe 'adding children to an element', ->
    el = document.querySelector '#fixtures .appendchild'
    newEl = document.createElement 'p'
    it 'should initially have no child elements', ->
      chai.expect(el.hasChildNodes()).to.equal false
    it 'should be able to add an element', (done) ->
      parent.send el
      child.send newEl
      setTimeout ->
        chai.expect(el.hasChildNodes()).to.equal true
        done()
      , 0
