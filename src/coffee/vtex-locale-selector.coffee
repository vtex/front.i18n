window.vtex.i18n.init = ->
	# Init i18next plugin
	i18n.init
		customLoad: (lng, ns, options, loadComplete) =>
			# Requires languages of VTEX Components
			if vtex.i18n.requireLang and vtex.curl
			  translationFiles = []
			  for requireLang in vtex.i18n.requireLang
			    translationFiles.push(requireLang+lng)
			  vtex.curl(translationFiles).then ->
			    loadComplete null, vtex.i18n[lng]
			else # Standard way
				dictionary = vtex.i18n[lng]
				if dictionary
					loadComplete null, dictionary
				else
					loadComplete null, vtex.i18n['pt-BR']
		lng: window.vtex.i18n.getLocale()
		load: 'current'
		fallbackLng: 'pt-BR'

	# Template for select2
	@template = """
		<select name='locale' id='vtex-locale-select'>
			<option></option>
			<option value='pt-BR'>Português Brasileiro</option>
			<option value='es'>Español</option>
			<option value='en-US'>American English</option>
		</select>
	"""

	# Insert template inside vtex-locale-selector element
	$('#vtex-locale-selector').html(@template)

	# Select label
	if i18n.t('global.changeLocale') is 'global.changeLocale'
		localeText = 'Mudar idioma'
	else 
		localeText = i18n.t('global.changeLocale')

	# Init select2 plugin
	$('#vtex-locale-select').select2({placeholder: localeText})

	# Change locale when another option is selected
	$('#vtex-locale-select').change (e, data) => window.vtex.i18n.setLocale(e.val)		

	# Translate page
	$('html').i18n()

	return