twilioResponses = require "#{process.cwd()}/services/twilio_responses"
callPolicy = require "#{process.cwd()}/services/call_policy"
zendesk = require "#{process.cwd()}/services/zendesk"

dependencies =
  twilioResponses: twilioResponses
  callPolicy: callPolicy
  zendesk: zendesk

exports.booking = require("./booking")(dependencies)

exports.index = (req, res) ->
  res.send twilioResponses.welcome()

exports.menu = (req, res) ->
  keyPressed = req.body.Digits

  if keyPressed is "1"
    res.send twilioResponses.enterBookingId()
  else if keyPressed is "2"
  else if keyPressed is "3"
  else if keyPressed is "5"
  else

exports.payByPhone = (req, res) ->
  inquiryId = req.body.inquiry_id
  callerId = req.body.from
  res.send twilioResponses.redirectToZendesk(callerId)

exports.fallback = (req, res) ->
  res.send twilioResponses.fallback()