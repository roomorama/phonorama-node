twilioResponses = require "#{process.cwd()}/services/twilio_responses"
callPolicy = require "#{process.cwd()}/services/call_policy"
zendesk = require "#{process.cwd()}/services/zendesk"

exports.inquiry = (req, res) ->
  inquiryId = req.body.Digits
  phoneNumber = req.body.From
  repeat = req.params.repeat || 1

  if repeat > 4
    res.send twilioResponses.hangUp()
  else
    callPolicy.inquiryValidForCall inquiryId, (valid, inquiry) ->
      if valid
        res.send twilioResponses.redirectToZendesk()
        zendesk.voiceCallUpdater.findCallAndUpdateInquiryId(phoneNumber, inquiryId)
      else
        repeat = parseInt(repeat) + 1
        res.send twilioResponses.invalidBookingId(repeat)

