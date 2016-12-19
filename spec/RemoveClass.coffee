noflo = require 'noflo'
baseDir = 'noflo-dom'

describe 'RemoveClass component', ->
  c = null
  element = null
  classSocket = null
  before (done) ->
    loader = new noflo.ComponentLoader baseDir
    loader.load 'dom/RemoveClass', (err, instance) ->
      return done err if err
      c = instance
      element = noflo.internalSocket.createSocket()
      classSocket = noflo.internalSocket.createSocket()
      c.inPorts.element.attach element
      c.inPorts.class.attach classSocket
      done()

  describe 'removing a class from an element', ->
    el = document.querySelector '#fixtures .removeclass'
    it 'should be able to remove the class', (done) ->
      element.send el
      classSocket.send 'foo'
      setTimeout ->
        chai.expect(el.classList.contains('foo')).to.equal false
        done()
      , 0
