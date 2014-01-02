module.exports = (grunt) ->
	pkg = grunt.file.readJSON('package.json')
	# Project configuration.
	grunt.initConfig
		# App variables
		relativePath: ''

		clean: ['build', 'dist']

		copy:
			main:
				expand: true
				cwd: 'src/'
				src: ['**', '!coffee/**', '!**/*.less']
				dest: 'build/<%= relativePath %>'
			test:
				expand: true
				cwd: 'spec/'
				src: ['**', '!**/*.coffee']
				dest: 'build/<%= relativePath %>/spec/'

		coffee:
			main:
				expand: true
				cwd: 'src/coffee'
				src: ['**/*.coffee']
				dest: 'build/<%= relativePath %>/js/'
				ext: '.js'

			dist:
				expand: true
				cwd: 'src/coffee'
				src: ['vtex-i18n.coffee', 'vtex-locale-selector.coffee']
				dest: 'dist/<%= relativePath %>/'
				ext: '.js'

		less:
			main:
				files:
					'build/<%= relativePath %>/style/main.css': 'src/style/main.less'

		useminPrepare:
			html: 'build/<%= relativePath %>/index.html'

		usemin:
			html: 'build/<%= relativePath %>/index.html'

		uglify:
			dist:
				files:
					'dist/vtex-i18n.min.js': ['dist/vtex-i18n.js']
					'dist/vtex-locale-selector.min.js': ['dist/vtex-locale-selector.js']

		karma:
			options:
				configFile: 'karma.conf.coffee'
			unit:
				background: true
			deploy:
				singleRun: true

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

	grunt.loadNpmTasks name for name of pkg.devDependencies when name[0..5] is 'grunt-'

	grunt.registerTask 'default', ['dev-watch']

	# Dev
	grunt.registerTask 'dev', ['clean', 'copy', 'coffee', 'less']
	grunt.registerTask 'dev-watch', ['dev', 'connect', 'watch:dev']

	# Prod - minifies files
	grunt.registerTask 'prod', ['dev', 'useminPrepare', 'concat', 'uglify', 'cssmin', 'usemin']
	grunt.registerTask 'prod-watch', ['prod', 'connect', 'watch:prod']

	# Test
	grunt.registerTask 'test', ['dev', 'connect' ,'karma:deploy']
	grunt.registerTask 'tdd', ['dev', 'connect', 'karma:unit', 'watch:test']

	# Dist
	grunt.registerTask 'dist', ['clean', 'coffee:dist', 'uglify:dist']