noflo = require 'noflo'
baseDir = 'noflo-dom'

describe 'AppendChild component', ->
  c = null
  parent = null
  child = null
  before (done) ->
    @timeout 4000
    loader = new noflo.ComponentLoader baseDir
    loader.load 'dom/AppendChild', (err, instance) ->
      return done err if err
      c = instance
      parent = noflo.internalSocket.createSocket()
      child = noflo.internalSocket.createSocket()
      c.inPorts.parent.attach parent
      c.inPorts.child.attach child
      done()

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
