Sequelize = require("sequelize")
config = require "#{process.cwd()}/config"

roomoramaDb = new Sequelize config.roomoramaDb.database,
  config.roomoramaDb.user,
  config.roomoramaDb.password,
  config.roomoramaDb.options

Inquiry = roomoramaDb.define 'inquiries',
  id:
    type: Sequelize.INTEGER
    autoIncrement: true
    primaryKey: true
  state: Sequelize.TEXT

exports.Inquiry = Inquiry