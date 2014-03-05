class Booking
  constructor: (dependencies) ->
    twilioResponses = dependencies.twilioResponses
    callPolicy = dependencies.callPolicy
    zendesk = dependencies.zendesk

    @inquiry = (req, res) ->
      inquiryId = req.body.Digits
      phoneNumber = req.body.From
      repeat = req.params.repeat || 1

      callPolicy.inquiryValidForCall inquiryId, (valid, inquiry) ->
        if valid
          res.send twilioResponses.redirectToZendesk()
          zendesk.voiceCallUpdater.findCallAndUpdateInquiryId(phoneNumber, inquiryId)
        else
          if repeat > 4
            res.send twilioResponses.hangUp()
          else
            repeat = parseInt(repeat) + 1
            res.send twilioResponses.invalidBookingId(repeat)

module.exports = (dependencies) ->
  new Booking(dependencies)