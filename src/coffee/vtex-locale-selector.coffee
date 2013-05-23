window.vtex = window.vtex || {}
window.vtex.i18n = vtex.i18n || {}
window.vtex.i18n.init = (locale) ->
	###
	# Seta @locale caso seja passado um locale como parametro
	# Por default seta @locale como o que está definido no atributo lang da tag html
	# Fallback para pt-BR
	###
	@locale = locale or $('html').attr('lang') or 'pt-BR'

	###
	# Caso o callback seja do tipo function, chama a função
	# Caso seja do tipo string assume-se que será chamado um canal do Radio
	###
	@callLocaleCallback = (val) => 
		if typeof(@localeCallback) is 'function'
			@localeCallback(val)
		else if (typeof(@localeCallback) is 'string' and window.radio)
			radio(@localeCallback).broadcast(val)

	@callCountryCodeCallback = (val) => 
		if typeof(@countryCodeCallback) is 'function'
			@countryCodeCallback(val)
		else if (typeof(@countryCodeCallback) is 'string' and window.radio)
			radio(@countryCodeCallback).broadcast(val)

	# Inicializa i18n
	i18n.init
		customLoad: (lng, ns, options, loadComplete) =>
			dictionary = vtex.i18n[lng]
			if dictionary
				loadComplete null, dictionary
			else
				loadComplete null, vtex.i18n['pt-BR']
		lng: @locale
		load: "current"
		fallbackLng: 'pt-BR'

	# Template
	@template = """
		<select name="locale" id="vtex-locale-select">
			<option></option>
			<option value="pt-BR">Português Brasileiro</option>
			<option value="es-AR">Español Argentino</option>
			<option value="en-US">American English</option>
		</select>
	"""
	# Insere template no elemento com o id vtex-locale-selector
	$('#vtex-locale-selector').html(@template)

	# Label do select
	if i18n.t('global.changeLocale') is 'global.changeLocale' 
		localeText = 'Mudar idioma' 
	else 
		localeText = i18n.t('global.changeLocale')	

	# Inicializa Select2
	$("#vtex-locale-select").select2
		placeholder: localeText

	# Troca lingua ao mudar option do select
	$("#vtex-locale-select").change (e, data) =>
		window.vtex.i18n.setLocale(e.val, @callLocaleCallback)		

	# Traduz strings
	$('html').i18n()

	# Chama locale callback
	@callLocaleCallback(@locale)

	return

# Código do país
window.vtex.i18n.countryCode = "BRA"

# Moedas de acordo com o país
window.vtex.i18n.getCurrencySymbol = (country = window.vtex.i18n.countryCode) ->
	switch country
		when 'BRA'
			return 'R$ '
		when 'USA'
			return 'US$ '
		else
			return '$ '

window.vtex.i18n.setLocaleCallback = (callback) ->
	@localeCallback = callback

window.vtex.i18n.setCountryCodeCallback = (callback) ->
	@countryCodeCallback = callback	

window.vtex.i18n.setLocale = (locale) ->
	window.i18n.setLng(locale)
	$('html').i18n()
	$("#vtex-locale-select").select2("val", locale)
	@callLocaleCallback(locale)

window.vtex.i18n.setCountryCode = (countryCode) ->
	window.vtex.i18n.countryCode = countryCode
	@callCountryCodeCallback(countryCode)