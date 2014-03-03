roomoramaDb = require "#{process.cwd()}/services/roomorama_db"
roomoramaDb.Inquiry.sync()

describe "Inquiry", ->
  it "is defined", ->
    expect(roomoramaDb.Inquiry).toBeDefined()

  it "finds an inquiry from roomorama db", (done) ->
    setupDone = false
    runs ->
      roomoramaDb.Inquiry.create(state: "host_to_enter_code").success (task) ->
        setupDone = true

    waitsFor ->
      setupDone == true

    runs ->
      roomoramaDb.Inquiry.find(where:
        state: "host_to_enter_code").success (inquiry) ->
          expect(inquiry.state).toEqual("host_to_enter_code")
          done()

  it "returns null when inquiry is not found", (done) ->
    roomoramaDb.Inquiry.find(1000).success (inquiry) ->
      expect(inquiry).toEqual(undefined)
      done()