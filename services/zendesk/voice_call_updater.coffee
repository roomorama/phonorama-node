helper = require './helper'
apiClient = require './api_client'
logger = require "#{process.cwd()}/lib/custom_logger"
_ = require "#{process.cwd()}/lib/underscore"

class VoiceCallUpdater
  findCallAndUpdateInquiryId: (number, inquiryId, callback = ()->) ->
    logger.info "looking for ticket from number - #{number}, inquiry - #{inquiryId}"
    self = @
    @.findCall number, (ticket) ->
      if ticket
        logger.info "found ticket - #{ticket.id} for number - #{number}, inquiry - #{inquiryId}"
        self.updateTicketInquiryId ticket, inquiryId, callback
      else
        logger.info "failed to find ticket: number - #{number}, inquiry - #{inquiryId}"
        callback(null)

  updateTicketInquiryId: (ticket, inquiryId, callback) ->
    updatedTicket = _.clone(ticket)
    helper.inquiryIdField(updatedTicket).value = inquiryId
    apiClient.tickets.update ticket.id, ticket: updatedTicket, callback

  findCall: (number, callback, timeStart = new Date().getTime()) ->
    self = @
    if _.timeSince(timeStart).getSeconds() > 5
      callback(null)
    else
      self.findCallInRecentTickets number, (result) ->
        if result
          callback(result)
        else
          self.delayFindCall(number, callback, timeStart)

  delayFindCall: (number, callback, timeStart = new Date().getTime()) ->
    self = @
    setTimeout self.findCall(number, callback, timeStart), 1000

  findCallInRecentTickets: (number, callback) ->
    self = @
    apiClient.tickets.listRecent (err, req, tickets) ->
      callback(self.findTicketWithNumber number, tickets )

  findTicketWithNumber: (number, tickets) ->
    _.find tickets, (ticket) ->
      ticket.via.channel == 'voice' && _.getNumbers(ticket.via.source.from.phone) == _.getNumbers(number)

module.exports = new VoiceCallUpdater()