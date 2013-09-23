RemoveClass = require 'noflo-dom/components/RemoveClass.js'
socket = require('noflo').internalSocket

describe 'RemoveClass component', ->
  c = null
  element = null
  classSocket = null
  beforeEach ->
    c = RemoveClass.getComponent()
    element = socket.createSocket()
    classSocket = socket.createSocket()
    c.inPorts.element.attach element
    c.inPorts.class.attach classSocket

  describe 'removing a class from an element', ->
    el = document.querySelector '#fixtures .removeclass'
    it 'should be able to remove the class', (done) ->
      element.send el
      classSocket.send 'foo'
      setTimeout ->
        chai.expect(el.classList.contains('foo')).to.equal false
        done()
      , 0
