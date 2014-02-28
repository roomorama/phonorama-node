zendesk = require 'node-zendesk'
config = require "#{process.cwd()}/config"
_ = require "#{process.cwd()}/lib/underscore"

class Zendesk
  apiClient: zendesk.createClient
    username: "zendesk@roomorama.com"
    token: config.zendesk.accessToken
    remoteUri: "https://roomorama.zendesk.com/api/v2"

  inquiryIdField: (ticket) ->
    _.find ticket.custom_fields, (field) ->
      field.id == 21120254

  updateTicketInquiryId: (ticket, inquiryId, callback) ->
    updatedTicket = _.clone(ticket)
    @.inquiryIdField(updatedTicket).value = inquiryId
    @.apiClient.tickets.update ticket.id, ticket: updatedTicket, callback

  findCallAndUpdateInquiryId: (number, inquiryId, callback) ->
    self = @
    @.findCall number, (ticket) ->
      if ticket
        self.updateTicketInquiryId ticket, inquiryId, callback
      else
        callback(null)

  findCall: (number, callback, timeStart = new Date().getTime()) ->
    self = @
    if _.timeSince(timeStart).getMinutes() > 2
      callback(null)
    else
      self.findCallInRecentTickets number, (result) ->
        if result
          callback(result)
        else
          self.delayFindCall(number, callback, timeStart)

  delayFindCall: (number, callback, timeStart = new Date().getTime()) ->
    setTimeout self.findCall(number, callback, timeStart), 500

  findCallInRecentTickets: (number, callback) ->
    self = @
    @.apiClient.tickets.listRecent (err, req, tickets) ->
      callback(self.findTicketWithNumber number, tickets )

  findTicketWithNumber: (number, tickets) ->
    _.find tickets, (ticket) ->
      ticket.via.channel == 'voice' && _.getNumbers(ticket.via.source.from.phone) == _.getNumbers(number)



# createPayByPhoneTicket
#
# findRecentTicketManager
# findRecentTicket
# updateTicket


module.exports = new Zendesk()
