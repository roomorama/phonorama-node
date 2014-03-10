zendesk = require 'node-zendesk'
config = require "#{process.cwd()}/config"

apiClient = zendesk.createClient
  username: "zendesk@roomorama.com"
  token: config.zendesk.accessToken
  remoteUri: "https://roomorama.zendesk.com/api/v2"

module.exports = apiClient