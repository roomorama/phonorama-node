nock = require 'nock'
roomoramaAPI = require "#{process.cwd()}/services/roomorama_api"
config = require "#{process.cwd()}/config"
host = config.roomoramaAPI.host
path = "/internal/v1.0/tickets"

describe "roomoramaAPI", ->
  describe "createTicket", ->
    it "is defined", ->
      expect(roomoramaAPI.createTicket).toBeDefined()

    it "returns error when inquiry_id and ticket_class are not in params", (done) ->
      roomoramaAPI.createTicket {}, (result) ->
        expect(result.error).toEqual("inquiry_id and ticket_class must be defined")
        done()

    it "posts ticket create request to roomorama API", (done) ->
      nock(host).post(path).reply 200, id: 1, status: "new"

      roomoramaAPI.createTicket {inquiry_id: 1, ticket_class: "pay_by_phone"}, (result, response) ->
        expect(response.statusCode).toEqual(200)
        expect(result).toEqual id: 1, status: "new"
        done()

    describe "when ticket create fails", ->
      it "returns the failed response as it is", (done) ->
        nock(host).post(path).reply 500

        roomoramaAPI.createTicket {inquiry_id: 1, ticket_class: "pay_by_phone"}, (result, response) ->
          expect(response.statusCode).toEqual(500)
          done()