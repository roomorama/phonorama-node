Sequelize = require("sequelize")
config = require "#{process.cwd()}/config"
roomoramaDb = config.roomoramaDb

sequelize = new Sequelize roomoramaDb.database, roomoramaDb.user, roomoramaDb.password, roomoramaDb.options

Inquiry = sequelize.define 'inquiries',
  id:
    type: Sequelize.INTEGER
    autoIncrement: true
    primaryKey: true
  state: Sequelize.TEXT

exports.Inquiry = Inquiry
