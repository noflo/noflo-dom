noflo = require 'noflo'
baseDir = 'noflo-dom'

describe 'AddClass component', ->
  c = null
  element = null
  classSocket = null
  before (done) ->
    @timeout 4000
    loader = new noflo.ComponentLoader baseDir
    loader.load 'dom/AddClass', (err, instance) ->
      return done err if err
      c = instance
      element = noflo.internalSocket.createSocket()
      classSocket = noflo.internalSocket.createSocket()
      c.inPorts.element.attach element
      c.inPorts.class.attach classSocket
      done()

  describe 'adding a class to an element', ->
    el = document.querySelector '#fixtures .addclass'
    it 'should be able to add the class', (done) ->
      element.send el
      classSocket.send 'foo'
      setTimeout ->
        chai.expect(el.classList.contains('foo')).to.equal true
        done()
      , 0
