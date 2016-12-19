noflo = require 'noflo'
baseDir = 'noflo-dom'

describe 'CreateFragment component', ->
  c = null
  ins = null
  fragment = null
  before (done) ->
    loader = new noflo.ComponentLoader baseDir
    loader.load 'dom/CreateFragment', (err, instance) ->
      return done err if err
      c = instance
      ins = noflo.internalSocket.createSocket()
      fragment = noflo.internalSocket.createSocket()
      c.inPorts.in.attach ins
      c.outPorts.fragment.attach fragment
      done()

  describe 'creating a DocumentFragment', ->
    it 'should produce a new fragment', (done) ->
      fragment.on 'data', (data) ->
        chai.expect(data).to.be.instanceof DocumentFragment
        done()
      ins.send true
