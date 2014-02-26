twilio = require 'twilio'
express = require 'express'
rest = require 'restler'
roomoramaDb = require './app/roomorama_db'
dotenv = require 'dotenv'
dotenv.load();

twilioMiddleware = twilio.webhook(validate: false)

app = express()
app.use express.urlencoded()
app.use express.logger('dev')
app.use twilioMiddleware

# Initialize Stuff
app.roomoramaDb = roomoramaDb
app.roomoramaDb.connect();

app.param "inquiry", (req, res, next, id) ->
  Inquiry.find id, (err, user) ->
    if err
      next err
    else if inquiry
      req.inquiry = inquiry
      next()
    else
      next new Error("failed to load inquiry")

app.post '/', (req, res) ->
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

app.post '/menu', (req, res) ->
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

# Check if the booking entered is a valid inquiry, if so, redirect to booking/inquiry_id.
# Otherwise, state the error, and gather back to this URL, incrementing the repeat
app.post '/booking/enter(/:repeat)', (req, res) ->
  numberEntered = req.body.Digits
  resp = new twilio.TwimlResponse()

# Perform redirecting actions for a valid inquiry id. Redirect the current call to the Zendesk phone number,
# Then update the created ticket data.
app.post '/booking/:inquiry', (req, res) ->

app.post '/pay-by-phone', (req, res) ->
  inquiryId = req.param('inquiry_id')
  resp = new twilio.TwimlResponse()
  resp.dial {method: 'POST', record: false}, ->
    @.number '+18627666553'
  res.send resp
    
app.post '/fallback', twilio.webhook(validate: false), (req, res) ->
  resp = new twilio.TwimlResponse()
  resp.say {voice: 'alice'}, 'Sorry, there was an error processing your call'

module.exports = app
