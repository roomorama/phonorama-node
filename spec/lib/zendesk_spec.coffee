zendesk = require("#{process.cwd()}/lib/zendesk")
_ = require("#{process.cwd()}/lib/underscore")
fs = require('fs')


describe "zendesk", ->
  tickets = JSON.parse(fs.readFileSync("#{process.cwd()}/spec/fixtures/tickets.json"))
  foundTicket = tickets[4]

  describe "updateTicketInquiryId", ->
    it 'updates ticket with attributes in params', (done) ->
      spyOn(zendesk.apiClient.tickets, 'update').andCallFake (ticketId, updatedTicket, callback) ->
        setTimeout callback(updatedTicket.ticket), 10

      zendesk.updateTicketInquiryId foundTicket, '1234567', (updatedTicket) ->
        expect(zendesk.inquiryIdField(updatedTicket).value).toEqual('1234567')
        done()

  describe "findTicketWithNumber", ->
    it 'finds ticket with specified phone number from list of tickets', ->
      ticket = zendesk.findTicketWithNumber('+16617480240', tickets)
      expect(ticket.id).toEqual(12973)

    it 'finds ticket even if number has spaces formatted', ->
      ticket = zendesk.findTicketWithNumber('+1 6617480240', tickets)
      expect(ticket.id).toEqual(12973)

    it 'returns undefined if number if not found in tickets', ->
      ticket = zendesk.findTicketWithNumber('+12345', tickets)
      expect(ticket).toEqual(undefined)

  describe 'findCallInRecentTickets', ->
    describe 'with recent tickets', ->
      beforeEach ->
        spyOn(zendesk.apiClient.tickets, 'listRecent').andCallFake (callback) ->
          setTimeout callback(null, null, tickets), 10

      it 'calls zendesk API for recent tickets and calls findTicketWithNumber to find ticket', (done) ->
        zendesk.findCallInRecentTickets '+16617480240', (ticket) ->
          expect(ticket.id).toEqual(12973)
          done()

      it 'returns undefined if ticket is not found', (done) ->
        zendesk.findCallInRecentTickets '+180240', (ticket) ->
          expect(ticket).toEqual(undefined)
          done()

    describe 'without recent tickets', ->
      beforeEach ->
        spyOn(zendesk.apiClient.tickets, 'listRecent').andCallFake (callback) ->
          setTimeout callback(null, null, []), 10

      it 'returns undefined when there is no recent ticket', (done) ->
        zendesk.findCallInRecentTickets '+180240', (ticket) ->
          expect(ticket).toEqual(undefined)
          done()

  describe 'findCall', ->
    describe 'when over time limit', ->
      beforeEach ->
        spyOn(zendesk, 'findCallInRecentTickets')

      it 'does nothing if startTime is 2 minutes before current time', ->
        mockCallBack = jasmine.createSpy('mockCallBack')
        timeStart = new Date().getTime() - 1000 * 60 * 2 - 500

        zendesk.findCall('123', mockCallBack, timeStart)
        expect(zendesk.findCallInRecentTickets.calls.length).toEqual(0);

    describe 'when within time limit', ->
      it 'runs callback when ticket is found', (done) ->
        spyOn(zendesk, 'findCallInRecentTickets').andCallFake (number, callback) ->
          setTimeout callback(foundTicket), 10

        zendesk.findCall '+16617480240', (result) ->
          expect(result.id).toEqual(12973)
          done()

      it 'sets timeout and call itself again if ticket is not found', (done) ->
        spyOn(zendesk, 'findCallInRecentTickets').andCallFake (number, callback) ->
          setTimeout callback(undefined), 10
        spyOn(zendesk, 'delayFindCall').andCallFake (number, callback) ->
          setTimeout callback(undefined), 10

        zendesk.findCall '+16617480240', (result) ->
          expect(zendesk.delayFindCall).toHaveBeenCalled()
          done()

  describe 'findCallAndUpdateInquiryId', ->
    describe 'found ticket to update', ->

      it 'attempts to find a voice ticket matching number and set inquiry id', (done) ->
        spyOn(zendesk, 'findCall').andCallFake (number, callback) ->
          setTimeout callback(foundTicket), 10
        spyOn(zendesk, 'updateTicketInquiryId').andCallFake (ticket, inquiryId, callback) ->
          updatedTicket = _.clone(ticket)
          zendesk.inquiryIdField(updatedTicket).value = inquiryId
          setTimeout callback(updatedTicket), 10

        zendesk.findCallAndUpdateInquiryId '+16617480240', 1234567, (updatedTicket) ->
          expect(zendesk.inquiryIdField(updatedTicket).value).toEqual(1234567)
          done()

    it 'does nothing if no ticket is found', (done) ->
      spyOn(zendesk, 'findCall').andCallFake (number, callback) ->
        setTimeout callback(null), 10

      zendesk.findCallAndUpdateInquiryId '+16617480240', 1234567, (updatedTicket) ->
        expect(updatedTicket).toEqual(null)
        done()