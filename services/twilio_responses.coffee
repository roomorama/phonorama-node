twilio = require 'twilio'
config = require "#{process.cwd()}/config"

resp = ->
  new twilio.TwimlResponse()

exports.welcome = ->
  resp()
    .say({voice:'alice'}, "Thank you for calling Room'orama...")
    .gather({action: '/menu', repeat: true, timeout: 5, numDigits: 1}, ->
      @.say({voice: 'alice'}, "For questions regarding an existing inquiry or booking; press 1.")
        .say({voice: 'alice'}, "If you're calling to rent a room, apartment, or house; press 2.")
        .say({voice: 'alice'}, "For media and all other enquiries, please email info @ Room'orama .com.")
        .say({voice: 'alice'}, "A member of our customer support team will respond as soon as possible...")
        .say({voice: 'alice'}, "To repeat this menu, press the star key...")
    )

exports.invalidMenu = ->
  resp()
    .gather({action: "/menu", finishOnKey: '#', timeout: 5}, ->
      @.say(voice: 'alice', "That's not a valid menu selection. Please try again")
        .pause length: 2)

exports.enterBookingId = (repeat = 1) ->
  resp()
    .gather action: "/booking/inquiry/#{repeat}",
            finishOnKey: '#',
            timeout: 5, ->
              @.say(voice: 'alice', "Please enter your booking ID.")
              .pause length: 10

exports.invalidBookingId = (repeat = 1) ->
  resp()
    .gather action: "/booking/inquiry/#{repeat}",
            finishOnKey: '#',
            timeout: 5, ->
              @.say(voice: 'alice', "That's not a valid booking ID. Please try again")
              .pause length: 10

exports.redirectToZendesk = (params = {}) ->
  params.line = 'support' unless params.line
  callParams = {method: 'POST', record: false}
  callParams.callerId = params.callerId if params.callerId
  resp()
    .dial callParams, ->
      @.number if params.line == 'support' then config.zendesk.supportNumber else config.zendesk.conversionNumber

exports.fallback = ->
  resp()
    .say {voice: 'alice'}, 'Sorry, there was an error processing your call'

exports.hangUp = ->
  resp()
    .say({voice: "alice"}, "Goodbye.")
    .hangup()