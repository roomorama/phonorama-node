nock = require 'nock'
roomoramaAPI = require "#{process.cwd()}/services/roomorama_api"

describe "roomoramaAPI", ->
  describe "createTicket", ->
    it "is defined", ->
      expect(roomoramaAPI.createTicket).toBeDefined()

    it "returns error when inquiryId and ticketClass are not in params", (done) ->
      roomoramaAPI.createTicket {}, (result) ->
        expect(result.error).toEqual("InquiryId and TicketClass must be defined")
        done()

    it "posts ticket create request to roomorama API", (done) ->
      nock("http://api.roomorama.dev")
      .post '/internal/v1/tickets'
      .reply 200, id: 1, status: "new"

      roomoramaAPI.createTicket {inquiryId: 1, ticketClass: "pay_by_phone"}, (result, response) ->
        expect(response.statusCode).toEqual(200)
        expect(result).toEqual id: 1, status: "new"
        done()

    describe "when ticket create fails", ->
      it "returns the failed response as it is", (done) ->
        nock("http://api.roomorama.dev")
        .post '/internal/v1/tickets'
        .reply 500

        roomoramaAPI.createTicket {inquiryId: 1, ticketClass: "pay_by_phone"}, (result, response) ->
          expect(response.statusCode).toEqual(500)
          done()