require('mysql')
orm = require('orm')
fs = require('fs')

class RoomoramaDb
  constructor: ->
  dbConfig: ->
    switch process.env.NODE_ENV
      when 'production'
        host: process.env.ROOMORAMA_DATABASE_HOST,
        database: process.env.ROOMORAMA_DATABASE_NAME,
        user: process.env.ROOMORAMA_DATABASE_USER,
        protocol: "mysql",
        query: { pool: true }
      when 'staging'
        host: process.env.ROOMORAMA_DATABASE_HOST,
        database: process.env.ROOMORAMA_DATABASE_NAME,
        user: process.env.ROOMORAMA_DATABASE_USER,
        protocol: "mysql",
        query: { pool: true }
      else
        host: 'localhost',
        database: 'roomorama',
        user: 'root',
        port: '13306',
        protocol: "mysql",
        query: { pool: true },
        socketPath: '/opt/boxen/data/mysql/socket'

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