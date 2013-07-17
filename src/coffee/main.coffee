$ ->

	# Chamada padrão
	vtex.i18n.init()

	# Com Radio
	loadRadio = false # ligue isso para ver como fica com o Radio
	if window.radio and loadRadio
		radio('vtex.i18n.update').subscribe (val) =>
			console.log("Radio locale Callback chamado:", val)

		radio('vtex.countryCode.update').subscribe (val) =>
			console.log("Radio countryCode Callback chamado:", val)

		window.vtex.i18n.setLocaleCallback('vtex.i18n.update')
		window.vtex.i18n.setCountryCodeCallback('vtex.countryCode.update')
		window.vtex.i18n.init()

		radio('vtex.countryCode.submit').subscribe (data) ->
			window.vtex.i18n.setCountryCode(data)

		radio('vtex.i18n.submit').subscribe (data) ->
			window.vtex.i18n.setLocale(data)
