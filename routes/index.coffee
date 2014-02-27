twilio = require 'twilio'

exports.booking = require('./booking')

exports.index = (req, res) ->
  resp = new twilio.TwimlResponse()
  resp
    .say({voice:'alice'}, "Thank you for calling Room'orama...")
    .gather({action: '/menu', repeat: true, timeout: 5, numDigits: 1}, ->
      @.say({voice: 'alice'}, "For questions regarding an existing inquiry or booking; press 1.")
        .say({voice: 'alice'}, "If you're calling to rent a room, apartment, or house; press 2.")
        .say({voice: 'alice'}, "If you are a travel writer or blogger; press 3.")
        .say({voice: 'alice'}, "For marketing and media enquiries; press 4.")
        .say({voice: 'alice'}, "For questions regarding the Room'orama perks program; press 5.")
        .say({voice: 'alice'}, "For all other enquiries, please email info @ Room'orama .com.")
        .say({voice: 'alice'}, "A member of our customer support team will respond as soon as possible...")
        .say({voice: 'alice'}, "To repeat this menu, press the star key...")
    )
  res.send resp

exports.menu = (req, res) ->
  keyPressed = req.body.Digits
  resp = new twilio.TwimlResponse()
  if keyPressed is "1"
    resp.gather({action: "/booking/enter", finishOnKey: '#', timeout: 5}, ->
      @.say({voice: 'alice'}, "Please enter your booking ID.").pause(length: 10)
    )
  else if keyPressed is "2"
  else if keyPressed is "3"
  else if keyPressed is "5"
  else
  res.send resp

