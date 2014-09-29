callPolicy = require "#{process.cwd()}/services/call_policy"
roomoramaDb = require "#{process.cwd()}/services/roomorama_db"
roomoramaDb.Inquiry.sync()

describe "callPolicy", ->
  describe "inquiryValidForCall", ->

    it "returns true when inquiry is present", (done) ->
      inquiry = null

      runs ->
        roomoramaDb.Inquiry.create(state: "host_to_confirm").success (result) ->
          inquiry = result

      waitsFor ->
        inquiry

      runs ->
        callPolicy.inquiryValidForCall inquiry.id, (allow, result) ->
          expect(allow).toEqual(true)
          done()

    it "returns false when inquiry is not present", (done) ->
      callPolicy.inquiryValidForCall 99999, (allow, result) ->
        expect(allow).toEqual(false)
        done()