require('mysql')
orm = require('orm')
fs = require('fs')
_ = require "#{process.cwd()}/lib/underscore"

class RoomoramaDb
  constructor: ->
  dbConfig: ->
    switch process.env.NODE_ENV
      when 'development'
        host: 'localhost',
        database: 'roomorama',
        user: 'root',
        port: '13306',
        protocol: "mysql",
        query: { pool: true }
      else
        host: process.env.DATABASE_HOST,
        database: process.env.DATABASE_NAME,
        user: process.env.DATABASE_USER,
        protocol: "mysql",
        query: { pool: true }

  connect: ->
    self = @
    db = orm.connect @dbConfig()

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