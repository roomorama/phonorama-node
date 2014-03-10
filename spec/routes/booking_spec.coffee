routes = require "#{process.cwd()}/routes"
twilioResponses = require "#{process.cwd()}/services/twilio_responses"
callPolicy = require "#{process.cwd()}/services/call_policy"
zendesk = require "#{process.cwd()}/services/zendesk"
roomoramaAPI = require "#{process.cwd()}/services/roomorama_api"

describe "routes", ->
  describe "booking", ->
    req =
      body:
        Digits: '12341'
        From: '+1 982034123'
      params:
        repeat: 1

    res = send: jasmine.createSpy('res')

    describe "inquiry", ->
      describe "with valid inquiry", ->
        it "connects to zendesk and runs voiceCallUpdater", ->
          req.params.repeat = 5
          spyOn(twilioResponses, 'redirectToZendesk')
          spyOn(zendesk.voiceCallUpdater, 'findCallAndUpdateInquiryId')
          spyOn(callPolicy, 'inquiryValidForCall').andCallFake (inquiryId, callback) ->
            callback(true)

          runs ->
            routes.booking.inquiry(req, res)

          waitsFor ->
            res.send.calls.length > 0

          runs ->
            expect(twilioResponses.redirectToZendesk).toHaveBeenCalled()
            expect(zendesk.voiceCallUpdater.findCallAndUpdateInquiryId).toHaveBeenCalled()


      describe "with invalid inquiry", ->
        it "hangs up if repeat > 4", ->
          req.params.repeat = 5
          spyOn(twilioResponses, 'hangUp')
          spyOn(callPolicy, 'inquiryValidForCall').andCallFake (inquiryId, callback) ->
            callback(false)

          runs ->
            routes.booking.inquiry(req, res)

          waitsFor ->
            res.send.calls.length > 0

          runs ->
            expect(twilioResponses.hangUp).toHaveBeenCalled()

        it "askes for a valid inquiry if repeat less than 5", ->
          req.params.repeat = 2
          spyOn(twilioResponses, 'invalidBookingId')
          spyOn(callPolicy, 'inquiryValidForCall').andCallFake (inquiryId, callback) ->
            callback(false)

          runs ->
            routes.booking.inquiry(req, res)

          waitsFor ->
            res.send.calls.length > 0

          runs ->
            expect(twilioResponses.invalidBookingId).toHaveBeenCalled()

    describe "payByPhone", ->
      req.body.inquiry_id = '1234567'
      req.body.from = "999999"

      it "sets callerId, redirect to Zendesk, create pay by phone ticket and update inquiry id", ->
        spyOn(twilioResponses, 'redirectToZendesk')
        spyOn(zendesk.voiceCallUpdater, 'findCallAndUpdateInquiryId')
        spyOn(roomoramaAPI, 'createTicket')

        routes.booking.payByPhone(req, res)
        expect(twilioResponses.redirectToZendesk).toHaveBeenCalledWith(callerId: "999999")
        expect(zendesk.voiceCallUpdater.findCallAndUpdateInquiryId).toHaveBeenCalledWith("999999", "1234567", jasmine.any(Function))
        expect(roomoramaAPI.createTicket).toHaveBeenCalledWith({inquiry_id: '1234567', ticket_class: 'pay_by_phone'}, jasmine.any(Function))

      it "closes created payByPhoneTicket if findCallAndUpdateInquiryId is successful", ->
        mockPayByPhoneTicket = {id: 12345, status: 'new'}
        spyOn(twilioResponses, 'redirectToZendesk')
        spyOn(zendesk.apiClient.tickets, 'update')
        spyOn(zendesk.voiceCallUpdater, 'findCallAndUpdateInquiryId').andCallFake (callerId, InquiryId, callback) ->
          callback(true)
        spyOn(roomoramaAPI, 'createTicket').andCallFake (params, callback) ->
          callback(mockPayByPhoneTicket)

        runs ->
          routes.booking.payByPhone(req, res)

        waitsFor ->
          zendesk.apiClient.tickets.update.calls.length > 0

        runs ->
          expect(mockPayByPhoneTicket.status).toEqual('closed')
