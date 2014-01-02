module.exports = (config) ->
  config.set
    files: [
      'build/lib/bower_components/jquery/jquery.js',
      'build/lib/bower_components/i18next/i18next-1.6.3.min.js',
      'build/lib/bower_components/select2/select2.js',
      'build/lib/bower_components/radio/radio.js',
      'build/js/vtex-i18n.js',
      'build/js/vtex-locale-selector.js',
      'build/spec/helpers/jasmine-jquery.js',
      'build/spec/helpers/mock-ajax.js',
      {
        pattern: 'build/spec/fixtures/*.*',
        watched: true,
        included: false,
        served: true
      },
      'spec/**/*.coffee'
    ]
    frameworks: ['jasmine']
    browsers: ['PhantomJS']
    preprocessors:
      "**/*.coffee": "coffee"