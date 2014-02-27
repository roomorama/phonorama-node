GLOBAL._ = require 'underscore'
_.mixin
  capitalize: (string) ->
    string.charAt(0).toUpperCase() + string.substring(1).toLowerCase();

  camelize: (string) ->
    self = @
    string.replace(/\..*/,'').split(/[\W_-]/).map (pieces) ->
      self.capitalize(pieces)
    .join("")