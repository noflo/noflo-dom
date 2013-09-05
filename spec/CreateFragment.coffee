CreateFragment = require 'noflo-dom/components/CreateFragment.js'
socket = require('noflo').internalSocket

describe 'CreateFragment component', ->
  c = null
  ins = null
  fragment = null
  beforeEach ->
    c = CreateFragment.getComponent()
    ins = socket.createSocket()
    fragment = socket.createSocket()
    c.inPorts.in.attach ins
    c.outPorts.fragment.attach fragment

  describe 'creating a DocumentFragment', ->
    it 'should produce a new fragment', (done) ->
      fragment.on 'data', (data) ->
        chai.expect(data).to.be.instanceof DocumentFragment
        done()
      ins.send true
