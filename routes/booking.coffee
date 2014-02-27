twilioResponses = require "#{process.cwd()}/services/twilio_responses"
callPolicy = require "#{process.cwd()}/services/call_policy"

exports.inquiry = (req, res) ->
  inquiryId = req.body.Digits
  repeat = req.params.repeat

  if repeat > 4
    res.send twilioResponses.hangUp()
  else
    callPolicy.inquiryValidForCall inquiryId, (valid, inquiry) ->
      if valid
        res.send twilioResponses.redirectToZendesk()
      else
        repeat = parseInt(repeat) + 1
        res.send twilioResponses.invalidBookingId(repeat)

