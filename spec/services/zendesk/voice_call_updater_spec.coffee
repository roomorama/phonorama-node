zendesk = require("#{process.cwd()}/services/zendesk")
_ = require("#{process.cwd()}/lib/underscore")
fs = require('fs')

helper = zendesk.helper
apiClient = zendesk.apiClient
voiceCallUpdater = zendesk.voiceCallUpdater

describe "voiceCallUpdater", ->
  tickets = JSON.parse(fs.readFileSync("#{process.cwd()}/spec/fixtures/tickets.json"))
  foundTicket = tickets[4]

  describe "updateTicketInquiryId", ->
    it 'updates ticket with attributes in params', (done) ->
      spyOn(apiClient.tickets, 'update').andCallFake (ticketId, updatedTicket, callback) ->
        setTimeout callback(updatedTicket.ticket), 10

      voiceCallUpdater.updateTicketInquiryId foundTicket, '1234567', (updatedTicket) ->
        expect(helper.inquiryIdField(updatedTicket).value).toEqual('1234567')
        done()

  describe "findTicketWithNumber", ->
    it 'finds ticket with specified phone number from list of tickets', ->
      ticket = voiceCallUpdater.findTicketWithNumber('+16617480240', tickets)
      expect(ticket.id).toEqual(12973)

    it 'finds ticket even if number has spaces formatted', ->
      ticket = voiceCallUpdater.findTicketWithNumber('+1 6617480240', tickets)
      expect(ticket.id).toEqual(12973)

    it 'returns undefined if number if not found in tickets', ->
      ticket = voiceCallUpdater.findTicketWithNumber('+12345', tickets)
      expect(ticket).toEqual(undefined)

  describe 'findCallInRecentTickets', ->
    describe 'with recent tickets', ->
      beforeEach ->
        spyOn(apiClient.tickets, 'listRecent').andCallFake (callback) ->
          setTimeout callback(null, null, tickets), 10

      it 'calls zendesk API for recent tickets and calls findTicketWithNumber to find ticket', (done) ->
        voiceCallUpdater.findCallInRecentTickets '+16617480240', (ticket) ->
          expect(ticket.id).toEqual(12973)
          done()

      it 'returns undefined if ticket is not found', (done) ->
        voiceCallUpdater.findCallInRecentTickets '+180240', (ticket) ->
          expect(ticket).toEqual(undefined)
          done()

    describe 'without recent tickets', ->
      beforeEach ->
        spyOn(apiClient.tickets, 'listRecent').andCallFake (callback) ->
          setTimeout callback(null, null, []), 10

      it 'returns undefined when there is no recent ticket', (done) ->
        voiceCallUpdater.findCallInRecentTickets '+180240', (ticket) ->
          expect(ticket).toEqual(undefined)
          done()

  describe 'findCall', ->
    describe 'when over time limit', ->
      beforeEach ->
        spyOn(voiceCallUpdater, 'findCallInRecentTickets')

      it 'does nothing if startTime is 5 seconds before current time', ->
        mockCallBack = jasmine.createSpy('mockCallBack')
        timeStart = new Date().getTime() - 1000 * 5 - 500

        voiceCallUpdater.findCall('123', mockCallBack, timeStart)
        expect(voiceCallUpdater.findCallInRecentTickets.calls.length).toEqual(0);

    describe 'when within time limit', ->
      it 'runs callback when ticket is found', (done) ->
        spyOn(voiceCallUpdater, 'findCallInRecentTickets').andCallFake (number, callback) ->
          setTimeout callback(foundTicket), 10

        voiceCallUpdater.findCall '+16617480240', (result) ->
          expect(result.id).toEqual(12973)
          done()

      it 'sets timeout and call itself again if ticket is not found', (done) ->
        spyOn(voiceCallUpdater, 'findCallInRecentTickets').andCallFake (number, callback) ->
          setTimeout callback(undefined), 10
        spyOn(voiceCallUpdater, 'delayFindCall').andCallFake (number, callback) ->
          setTimeout callback(undefined), 10

        voiceCallUpdater.findCall '+16617480240', (result) ->
          expect(voiceCallUpdater.delayFindCall).toHaveBeenCalled()
          done()

  describe 'findCallAndUpdateInquiryId', ->
    describe 'found ticket to update', ->

      it 'attempts to find a voice ticket matching number and set inquiry id', (done) ->
        spyOn(voiceCallUpdater, 'findCall').andCallFake (number, callback) ->
          setTimeout callback(foundTicket), 10
        spyOn(voiceCallUpdater, 'updateTicketInquiryId').andCallFake (ticket, inquiryId, callback) ->
          updatedTicket = _.clone(ticket)
          helper.inquiryIdField(updatedTicket).value = inquiryId
          setTimeout callback(updatedTicket), 10

        voiceCallUpdater.findCallAndUpdateInquiryId '+16617480240', 1234567, (updatedTicket) ->
          expect(helper.inquiryIdField(updatedTicket).value).toEqual(1234567)
          done()

    it 'does nothing if no ticket is found', (done) ->
      spyOn(voiceCallUpdater, 'findCall').andCallFake (number, callback) ->
        setTimeout callback(null), 10

      voiceCallUpdater.findCallAndUpdateInquiryId '+16617480240', 1234567, (updatedTicket) ->
        expect(updatedTicket).toEqual(null)
        done()