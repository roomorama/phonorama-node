routes = require "#{process.cwd()}/routes"
twilioResponses = require "#{process.cwd()}/services/twilio_responses"

describe "routes", ->
  describe "inquiry", ->
    req =
      body:
        Digits: '12341'
        From: '+1 982034123'
      params:
        repeat: 1

    res = send: jasmine.createSpy('res')

    it "hangs up if repeat > 4", ->
      req.params.repeat = 5
      spyOn(twilioResponses, 'hangUp')
      routes.booking.inquiry(req, res)

      expect(twilioResponses.hangUp).toHaveBeenCalled()
      expect(res.send).toHaveBeenCalled()
