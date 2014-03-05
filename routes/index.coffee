dependencies =
  twilioResponses: require "#{process.cwd()}/services/twilio_responses"
  callPolicy: require "#{process.cwd()}/services/call_policy"
  zendesk: require "#{process.cwd()}/services/zendesk"
  roomoramaAPI: require "#{process.cwd()}/services/roomorama_api"

exports.booking = require("./booking")(dependencies)

exports.index = (req, res) ->
  res.send dependencies.twilioResponses.welcome()

exports.menu = (req, res) ->
  keyPressed = req.body.Digits

  if keyPressed is "1"
    res.send dependencies.twilioResponses.enterBookingId()
  else if keyPressed is "2"
  else if keyPressed is "3"
  else if keyPressed is "5"
  else

exports.fallback = (req, res) ->
  res.send dependencies.twilioResponses.fallback()