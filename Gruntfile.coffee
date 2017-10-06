module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    # Browser build of NoFlo
    noflo_browser:
      build:
        files:
          'browser/noflo-dom.js': ['package.json']
    # Generate runner.html
    noflo_browser_mocha:
      all:
        options:
          scripts: ["../browser/<%=pkg.name%>.js"]
          fixtures: """
            <div class="getattribute" foo="bar"></div>
            <div class="getelement">Foo</div>
            <div class="addclass">Foo</div>
            <div class="appendchild"></div>
            <div class="removeclass foo">Foo</div>
            <div class="setattribute" foo="bar"></div>
          """
        files:
          'spec/runner.html': ['spec/*.js', '!spec/fbpspec.js']

    # CoffeeScript compilation
    coffee:
      spec:
        options:
          bare: true
        expand: true
        cwd: 'spec'
        src: ['**.coffee']
        dest: 'spec'
        ext: '.js'

    # JavaScript minification for the browser
    uglify:
      options:
        report: 'min'
      noflo:
        files:
          './browser/noflo-dom.min.js': ['./browser/noflo-dom.js']

    # Automated recompilation and testing when developing
    watch:
      files: ['spec/*.coffee', 'components/*.coffee']
      tasks: ['test']

    # BDD tests on browser
    mocha_phantomjs:
      options:
        output: 'spec/result.xml'
        reporter: 'spec'
        failWithOutput: true
      all: ['spec/runner.html']

    # Coding standards
    coffeelint:
      components:
        options:
          max_line_length:
            level: "ignore"
        src: ['components/*.coffee']

    # Cross-browser testing
    connect:
      server:
        options:
          base: ''
          port: 9999

    'saucelabs-mocha':
      all:
        options:
          urls: ['http://127.0.0.1:9999/spec/runner.html']
          browsers: [
              browserName: 'chrome'
            #,
            #browserName: 'firefox'
            ,
              browserName: 'safari'
              platform: 'OS X 10.8'
              version: '6'
            ,
              browserName: 'internet explorer'
              platform: 'Windows 8.1',
              version: '11'
          ]
          build: process.env.TRAVIS_JOB_ID
          testname: 'noflo-dom browser tests'
          tunnelTimeout: 5
          concurrency: 1
          detailedError: true

  # Grunt plugins used for building
  @loadNpmTasks 'grunt-noflo-browser'
  @loadNpmTasks 'grunt-contrib-coffee'
  @loadNpmTasks 'grunt-contrib-uglify'

  # Grunt plugins used for testing
  @loadNpmTasks 'grunt-contrib-watch'
  @loadNpmTasks 'grunt-mocha-phantomjs'
  @loadNpmTasks 'grunt-coffeelint'

  # Grunt plugins used for browser testing
  @loadNpmTasks 'grunt-contrib-connect'
  @loadNpmTasks 'grunt-saucelabs'

  # Our local tasks
  @registerTask 'build', 'Build NoFlo for the chosen target platform', (target = 'all') =>
    if target is 'all' or target is 'browser'
      @task.run 'noflo_browser'
      @task.run 'uglify'

  @registerTask 'test', 'Build NoFlo and run automated tests', (target = 'all') =>
    @task.run 'coffeelint'
    @task.run "build:#{target}"
    if target is 'all' or target is 'browser'
      @task.run 'coffee'
      @task.run 'noflo_browser_mocha'
      @task.run 'mocha_phantomjs'

  @registerTask 'crossbrowser', 'Run tests on real browsers', ['test', 'connect', 'saucelabs-mocha']

  @registerTask 'default', ['test']
