rest = require 'restler'
config = require "#{process.cwd()}/config"

RoomoramaInternalAPI = rest.service (->),
  baseURL: config.roomoramaAPI.host
  timeout: 15000
  rejectUnauthorized: process.env.NODE_ENV == 'production'
  headers:
    'Authorization': "Bearer #{config.roomoramaAPI.accessToken}"
,
  createTicket: (data, callback) ->
    if data.inquiry_id && data.ticket_class
      @post "/internal/v1.0/tickets",
        data: data
      .on('complete', callback)
      .on('timeout', (ms) ->
        callback(error: "Timed out"))
    else
      callback(error: "inquiry_id and ticket_class must be defined")

module.exports = new RoomoramaInternalAPI()