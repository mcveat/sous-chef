module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-regarde'
  grunt.loadNpmTasks 'grunt-contrib-livereload'
  grunt.loadNpmTasks 'grunt-open'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.initConfig
    connect:
      all:
        options:
          port: 8000
          base: 'target'
          middleware: (connect, options) -> 
            [
              require('grunt-contrib-livereload/lib/utils').livereloadSnippet
              connect.static options.base
              connect.directory options.base
            ] 
    open:
      all:
        path: 'http://localhost:<%= connect.all.options.port%>'
    regarde:
      all: 
        files: ['app/**']
        tasks: ['build', 'livereload']
    copy:
      static:
        files: [
          { expand: true, cwd: 'app/html/', src: ['*.html'], dest: 'target' },
          { expand: true, cwd: 'app/js/', src: ['**'], dest: 'target/js' }
          { expand: true, cwd: 'app/css/', src: ['**'], dest: 'target/css' }
          { expand: true, cwd: 'app/img/', src: ['**'], dest: 'target/img' }
          { expand: true, cwd: 'app/snd/', src: ['**'], dest: 'target/snd' }
          { expand: true, cwd: 'app/swf/', src: ['**'], dest: 'target/swf' }
        ]
    coffee:
      compile:
        files:
          'target/js/main.js': ['app/coffee/*.coffee']
 
  grunt.registerTask 'build', ['copy:static', 'coffee:compile']
  grunt.registerTask 'default', ['build', 'livereload-start', 'connect', 'open', 'regarde']