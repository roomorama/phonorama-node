roomoramaDb = require "#{process.cwd()}/services/roomorama_db"
roomoramaDb.connect()

describe 'Inquiry', ->
  beforeEach ->

  it 'responds to get', ->
    waitsFor ->
      roomoramaDb.Inquiry != undefined
    , 'should have Inquiry defined', 1000

    runs ->
      expect(typeof roomoramaDb.Inquiry.get).toEqual('function')

