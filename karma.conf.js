files = [
	JASMINE,
	JASMINE_ADAPTER,
	'build/lib/jquery/jquery-1.8.3.min.js',
	'build/lib/i18next-1.6.0.min.js',
	'build/lib/select2/select2.min.js',
	'build/lib/radio.min.js',
	'build/js/vtex-i18n.js',
	'build/js/vtex-locale-selector.js',
	'build/spec/helpers/jasmine-jquery.js',
	'build/spec/helpers/mock-ajax.js',
	{
		pattern: 'build/spec/fixtures/**/*.*',
		watched: true,
		included: false,
		served: true
	},
	'build/spec/*.js'
];
browsers = [
	'PhantomJS'
];