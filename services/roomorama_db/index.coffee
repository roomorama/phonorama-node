require('mysql')
orm = require('orm')
fs = require('fs')
configuration = require "#{process.cwd()}/config"
_ = require "#{process.cwd()}/lib/underscore"

class RoomoramaDb
  constructor: ->

  connect: ->
    self = @
    db = orm.connect configuration.roomoramaDb

    db.on "connect", (err) ->
      self.defineModels(db)

  defineModels: (db) ->
    models = fs.readdirSync(__dirname + '/models')
    models.forEach (filename) ->
      modelName = _.camelize(filename)
      model = require('./models/' + filename)
      @[modelName] = model.define(db)
    , @

module.exports = new RoomoramaDb()