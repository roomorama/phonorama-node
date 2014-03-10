module.exports = (grunt) ->
  @loadNpmTasks('grunt-express-server')
  @loadNpmTasks('grunt-contrib-watch')

  grunt.initConfig
    express:
      options:
        cmd: 'coffee'
      # Override defaults here
      dev:
        options:
          script: "server.coffee"
      prod:
        options:
          script: "server.coffee"
          node_env: "production"
      test:
        options:
          script: "server.coffee"
    watch:
      express:
        files: [ '**/*.coffee' ]
        tasks:  [ 'express:dev' ]
        options:
          spawn: false

  grunt.registerTask('server', [ 'express:dev', 'watch' ])