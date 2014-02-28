underscore = require 'underscore'
underscore.mixin
  capitalize: (string) ->
    string.charAt(0).toUpperCase() + string.substring(1).toLowerCase();

  camelize: (string) ->
    self = @
    string.replace(/\..*/,'').split(/[\W_-]/).map (pieces) ->
      self.capitalize(pieces)
    .join("")

  getNumbers: (string) ->
    string.replace(/\D/g, '')

  timeSince: (timeMs) ->
    diff = new Date().getTime() - timeMs
    getHours: -> diff/(1000*60*60)
    getMinutes: -> diff/(1000*60)
    getSeconds: -> diff/(1000)

module.exports = underscore