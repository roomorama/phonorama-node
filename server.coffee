twilio = require 'twilio'
express = require 'express'
rest = require 'restler'
twilioMiddleware = twilio.webhook(validate: false)

app = express()
app.use express.urlencoded()
app.use express.logger('dev')
app.use twilioMiddleware

app.post '/', (req, res) ->
  resp = new twilio.TwimlResponse()
  resp
  .say({voice:'alice'}, "Thank you for calling Room'orama...")
  .gather({action: '/menu', repeat: true, timeout: 5}, ->
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


app.post '/pay-by-phone', (req, res) ->
  inquiryId = req.param('inquiry_id')
  resp = new twilio.TwimlResponse()
  resp.dial {method: 'POST', record: false}, ->
    @.number '+18627666553'
  res.send resp
    
app.post '/fallback', twilio.webhook(validate: false), (req, res) ->
  resp = new twilio.TwimlResponse()
  resp.say {voice: 'alice'}, 'Sorry, there was an error processing your call'

app.listen(process.env.PORT || 3000)