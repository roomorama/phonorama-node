callPolicy = require "#{process.cwd()}/services/call_policy"
roomoramaDb = require "#{process.cwd()}/services/roomorama_db"
roomoramaDb.Inquiry.sync()

describe "callPolicy", ->
  describe "inquiryValidForCall", ->

    it "returns true when inquiry has state host_to_confirm", (done) ->
      inquiry = null

      runs ->
        roomoramaDb.Inquiry.create state: "host_to_confirm"
        .success (result) ->
          inquiry = result

      waitsFor ->
        inquiry

      runs ->
        callPolicy.inquiryValidForCall inquiry.id, (allow, result) ->
          expect(allow).toEqual(true)
          done()

    it "returns true when inquiry has state guest_to_pay", (done) ->
      inquiry = null

      runs ->
        roomoramaDb.Inquiry.create state: "guest_to_pay"
        .success (result) ->
            inquiry = result

      waitsFor ->
        inquiry

      runs ->
        callPolicy.inquiryValidForCall inquiry.id, (allow, result) ->
          expect(allow).toEqual(true)
          done()

    it "returns true when inquiry has state cancelled", (done) ->
      inquiry = null

      runs ->
        roomoramaDb.Inquiry.create state: "cancelled"
        .success (result) ->
            inquiry = result

      waitsFor ->
        inquiry

      runs ->
        callPolicy.inquiryValidForCall inquiry.id, (allow, result) ->
          expect(allow).toEqual(true)
          done()

    it "returns false when inquiry has state declined", (done) ->
      inquiry = null

      runs ->
        roomoramaDb.Inquiry.create state: "declined"
        .success (result) ->
          inquiry = result

      waitsFor ->
        inquiry

      runs ->
        callPolicy.inquiryValidForCall inquiry.id, (allow, result) ->
          expect(allow).toEqual(false)
          done()