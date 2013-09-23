AddClass = require 'noflo-dom/components/AddClass.js'
socket = require('noflo').internalSocket

describe 'AddClass component', ->
  c = null
  element = null
  classSocket = null
  beforeEach ->
    c = AddClass.getComponent()
    element = socket.createSocket()
    classSocket = socket.createSocket()
    c.inPorts.element.attach element
    c.inPorts.class.attach classSocket

  describe 'adding a class to an element', ->
    el = document.querySelector '#fixtures .addclass'
    it 'should be able to add the class', (done) ->
      element.send el
      classSocket.send 'foo'
      setTimeout ->
        chai.expect(el.classList.contains('foo')).to.equal true
        done()
      , 0
