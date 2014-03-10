twilioResponses = require "#{process.cwd()}/services/twilio_responses"

exports.booking = require("./booking")

exports.index = (req, res) ->
  res.send twilioResponses.welcome()

exports.menu = (req, res) ->
  keyPressed = req.body.Digits

  if keyPressed is "1"
    res.send twilioResponses.enterBookingId()
  else if keyPressed is "2"
    res.send twilioResponses.redirectToZendesk(line: 'conversion')
  else
    res.send twilioResponses.invalidMenu()

exports.fallback = (req, res) ->
  res.send twilioResponses.fallback()