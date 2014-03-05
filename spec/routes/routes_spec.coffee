routes = require "#{process.cwd()}/routes"
twilioResponses = require "#{process.cwd()}/services/twilio_responses"
callPolicy = require "#{process.cwd()}/services/call_policy"
zendesk = require "#{process.cwd()}/services/zendesk"

describe "routes", ->
  describe "inquiry", ->
    req =
      body:
        Digits: '12341'
        From: '+1 982034123'
      params:
        repeat: 1

    res = send: jasmine.createSpy('res')

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