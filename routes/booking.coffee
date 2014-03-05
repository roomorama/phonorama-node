twilioResponses = require "#{process.cwd()}/services/twilio_responses"
callPolicy = require "#{process.cwd()}/services/call_policy"
zendesk = require "#{process.cwd()}/services/zendesk"
roomoramaAPI = require "#{process.cwd()}/services/roomorama_api"

exports.inquiry = (req, res) ->
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

exports.payByPhone = (req, res) ->
  inquiryId = req.body.inquiry_id
  callerId = req.body.from
  payByPhoneTicket = null

  res.send twilioResponses.redirectToZendesk callerId
  roomoramaAPI.createTicket { inquiry_id: inquiryId, ticket_class: 'pay_by_phone' }, (ticket) ->
                              payByPhoneTicket = ticket

  zendesk.voiceCallUpdater.findCallAndUpdateInquiryId callerId, inquiryId, (ticket) ->
    if ticket && payByPhoneTicket
      payByPhoneTicket.status = 'closed'
      zendesk.apiClient.tickets.update payByPhoneTicket.id, payByPhoneTicket