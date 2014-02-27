fs = require('fs')

class Services
  constructor: ->
    @loadServices()

  loadServices: ->
    services = fs.readdirSync(process.cwd()+'/app/services')
    services.forEach (filename) ->
      serviceName = _.camelize(filename)
      service = require('./services/' + filename)
      @[serviceName] = service
    , @

module.exports = new Services()