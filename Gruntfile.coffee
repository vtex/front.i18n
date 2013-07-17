path = require('path')
fs = require('fs')

module.exports = (grunt) ->
	pacha = grunt.file.readJSON('tools/pachamama/pachamama.config')[0]
	# Project configuration.
	grunt.initConfig
		resourceToken: process.env['RESOURCE_TOKEN'] or '/io'
		gitCommit: process.env['GIT_COMMIT'] or 'GIT_COMMIT'
		deployDirectory: path.normalize(process.env['DEPLOY_DIRECTORY'] ? 'deploy')
		relativePath: ''
		pkg: grunt.file.readJSON('package.json')
		pacha: pacha
		acronym: pacha.acronym
		environmentName: process.env['ENVIRONMENT_NAME'] or '1-0-0'
		buildNumber: process.env['BUILD_NUMBER'] or '1'
		environmentType: process.env['ENVIRONMENT_TYPE'] or 'stable'
		versionName: -> [grunt.config('acronym'), grunt.config('environmentName'), grunt.config('buildNumber'),
										 grunt.config('environmentType')].join('-')
		clean: ['build']
		copy:
			main:
				expand: true
				cwd: 'src/'
				src: ['**', '!includes/**', '!coffee/**', '!**/*.less']
				dest: 'build/<%= relativePath %>'

			test: 
				expand: true
				cwd: 'spec/'
				src: ['**', '!**/*.coffee']
				dest: 'build/<%= relativePath %>/spec/'

			debug:
				src: ['src/index.html']
				dest: 'build/<%= relativePath %>/index.debug.html'

			deploy:
				expand: true
				cwd: 'build/<%= relativePath %>/'
				src: ['**', '!includes/**', '!coffee/**', '!**/*.less']
				dest: '<%= deployDirectory %>/<%= gitCommit %>/'

			env:
				expand: true
				cwd: '<%= deployDirectory %>/<%= gitCommit %>/'
				src: ['**']
				dest: '<%= deployDirectory %>/<%= versionName() %>/'

		coffee:
			main:
				expand: true
				cwd: 'src/coffee'
				src: ['**/*.coffee']
				dest: 'build/<%= relativePath %>/js/'
				ext: '.js'

			test:
				expand: true
				cwd: 'spec/'
				src: ['**/*.coffee']
				dest: 'build/<%= relativePath %>/spec/'
				ext: '.js'

		less:
			main:
				files:
					'build/<%= relativePath %>/style/main.css': 'src/style/main.less'

		useminPrepare:
			html: 'build/<%= relativePath %>/index.html'

		usemin:
			html: 'build/<%= relativePath %>/index.html'

		karma:
			options:
				configFile: 'karma.conf.js'
			unit:
				background: true
			deploy:
				singleRun: true

		'string-replace':
			deploy:
				files:
					'<%= deployDirectory %>/<%= versionName() %>/index.html': ['<%= deployDirectory %>/<%= versionName() %>/index.html']
					'<%= deployDirectory %>/<%= versionName() %>/index.debug.html': ['<%= deployDirectory %>/<%= versionName() %>/index.debug.html']

				options:
					replacements: [
						pattern: /src="(\.\.\/)?(?!http|\/|\/\/|\#)/ig
						replacement: 'src="/io/messages/'
					,
						pattern: /href="(\.\.\/)?(?!http|\/|\/\/|\#)/ig
						replacement: 'href="/io/messages/'
					,
						pattern: '<script src="http://localhost:35729/livereload.js"></script>'
						replacement: ''
					]

		connect:
			dev:
				options:
					port: 9001
					base: 'build/'

		watch:
			options:
				livereload: true

			dev:
				files: ['src/**/*.html', 'src/**/*.coffee', 'src/**/*.js', 'src/**/*.less']
				tasks: ['dev']

			prod:
				files: ['src/**/*.html', 'src/**/*.coffee', 'src/**/*.js', 'src/**/*.less']
				tasks: ['prod']

			test:
				files: ['src/**/*.html', 'src/**/*.coffee', 'src/**/*.js', 'src/**/*.less', 'spec/**/*.*']
				tasks: ['dev', 'karma:unit:run']

	grunt.loadNpmTasks 'grunt-contrib-connect'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-less'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-cssmin'
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-usemin'
	grunt.loadNpmTasks 'grunt-string-replace'
	grunt.loadNpmTasks 'grunt-karma'

	grunt.registerTask 'default', ['dev-watch']

	# Dev
	grunt.registerTask 'dev', ['clean', 'copy:main', 'copy:test', 'coffee', 'less']
	grunt.registerTask 'dev-watch', ['dev', 'connect', 'remote', 'watch:dev']

	# Prod - minifies files
	grunt.registerTask 'prod', ['dev', 'copy:debug', 'useminPrepare', 'concat', 'uglify', 'cssmin', 'usemin']
	grunt.registerTask 'prod-watch', ['prod', 'connect', 'remote', 'watch:prod']

	# Test
	grunt.registerTask 'test', ['dev', 'karma:deploy']
	grunt.registerTask 'test-watch', ['dev', 'karma:unit', 'watch:test']

	# TDD
	grunt.registerTask 'tdd', ['dev', 'connect', 'remote', 'karma:unit', 'watch:test']

	# Generates version folder
	grunt.registerTask 'gen-version', ->
		grunt.log.writeln 'Deploying to environmentName: '.cyan + grunt.config('environmentName').green
		grunt.log.writeln 'Deploying to buildNumber: '.cyan + grunt.config('buildNumber').green
		grunt.log.writeln 'Deploying to environmentType: '.cyan + grunt.config('environmentType').green
		grunt.log.writeln 'Directory: '.cyan + grunt.config('versionName')().green
		grunt.log.writeln 'Version set to: '.cyan + grunt.config('gitCommit').green
		grunt.log.writeln 'Rersource token set to: '.cyan + grunt.config('resourceToken').green
		grunt.log.writeln 'Deploy folder: '.cyan + grunt.config('deployDirectory').green
		grunt.task.run ['copy:env', 'string-replace:deploy']

	# Deploy - creates deploy folder structure
	grunt.registerTask 'deploy', ->
		commit = grunt.config('gitCommit')
		deployDir = path.resolve grunt.config('deployDirectory'), commit
		deployExists = false
		grunt.log.writeln 'Version deploy dir set to: '.cyan + deployDir.green
		try
			deployExists = fs.existsSync deployDir
		catch e
			grunt.log.writeln 'Error reading deploy folder'.red
			console.log e

		if deployExists
			grunt.log.writeln 'Folder '.cyan + deployDir.green + ' already exists.'.cyan
			grunt.log.writeln 'Skipping build process and generating environmentType folder.'.cyan
			grunt.task.run ['clean', 'gen-version']
		else
			grunt.task.run ['prod', 'karma:deploy', 'copy:deploy', 'gen-version']

	#	Remote task
	grunt.registerTask 'remote', 'Run Remote proxy server', ->
		require 'coffee-script'
		require('remote')()