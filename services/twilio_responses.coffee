twilio = require 'twilio'
config = require "#{process.cwd()}/config"
zendeskNumber = config.zendesk.phoneNumber

resp = ->
  new twilio.TwimlResponse()

exports.welcome = ->
  resp()
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

exports.enterBookingId = (repeat = 1) ->
  resp()
    .gather action: "/booking/inquiry/#{repeat}",
            finishOnKey: '#',
            timeout: 5, ->
              @.say voice: 'alice', "Please enter your booking ID."
                .pause length: 10

exports.invalidBookingId = (repeat = 1) ->
  resp()
    .gather action: "/booking/inquiry/#{repeat}",
            finishOnKey: '#',
            timeout: 5, ->
              @.say voice: 'alice', "That's not a valid booking ID. Please try again"
                .pause length: 10


exports.redirectToZendesk = (callerId) ->
  callParams = {method: 'POST', record: false}
  callParams.callerId = callerId if callerId
  resp()
    .dial callParams, ->
      @.number zendeskNumber

exports.fallback = ->
  resp()
    .say {voice: 'alice'}, 'Sorry, there was an error processing your call'

exports.hangUp = ->
  resp()
    .say({voice: "alice"}, "Goodbye.")
    .hangup()