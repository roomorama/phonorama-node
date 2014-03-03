rest = require 'restler'
config = require "#{process.cwd()}/config"


RoomoramaInternalAPI = rest.service ->
,
baseURL: config.roomoramaAPI.uri
headers:
  'Authorization': "Bearer #{config.roomoramaAPI.accessToken}"
timeout: 1000,
{ createTicket: (data, callback) ->
    if data.inquiryId && data.ticketClass
      @post "#{config.roomoramaAPI.uri}/tickets",
        data: data
      .on 'complete', callback
    else
      callback(error: "InquiryId and TicketClass must be defined")
}

module.exports = new RoomoramaInternalAPI()