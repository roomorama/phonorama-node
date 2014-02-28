zendesk = require 'node-zendesk'
config = require "#{process.cwd()}/config"
_ = require "#{process.cwd()}/lib/underscore"

class zendeskApi
  apiClient: zendesk.createClient
    username: "zendesk@roomorama.com"
    token: config.zendesk.accessToken
    remoteUri: "https://roomorama.zendesk.com/api/v2"

  updateTicket: (ticketId, params, callback) ->
    apiClient.tickets.update ticketId, ticket: params, callback

  repeatFindCall: (number, callback, timeStart = new Date().getTime()) ->
    self = @
    unless _.timeSince(timeStart).getMinutes() > 2
      findCallInRecentTickets number, (result) ->
        if result
          callback(result)
        else
          self.repeatFindCall(number, callback, timeStart)

  findCallInRecentTickets: (number, callback) ->
    self = @
    @.apiClient.tickets.listRecent (err, req, tickets) ->
      callback(self.findCall number, tickets )

  findCall: (number, tickets) ->
    tickets.forEach (ticket) ->
      if ticket.via.channel == 'voice' && _.getNumbers(ticket.via.source.from.phone) == _.getNumbers(number)
        ticket.id
      else
        null




# createPayByPhoneTicket
#
# findRecentTicketManager
# findRecentTicket
# updateTicket


module.exports = new zendeskApi()
