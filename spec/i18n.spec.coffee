jasmine.getFixtures().fixturesPath = 'base/build/spec/fixtures'
jasmine.getJSONFixtures().fixturesPath = 'base/build/spec/fixtures'

describe 'i18n', ->

	it 'should have dependencies to be defined', ->
		expect($).toBeDefined()

	describe 'based on a page that contains lang attribute and meta tags', ->

		beforeEach ->
			loadFixtures 'complete.html'
			# Reset variables
			$.extend(window.vtex.i18n, new window.vtex.VtexI18n())

		it 'should set the default locale based on the lang attribute of html tag', ->
			# Arrange

			# Act
			locale = vtex.i18n.getLocale()

			# Assert
			expect(locale).toMatch('en-US')

		it 'should set the default countryCode based on the meta country tag', ->
			# Arrange

			# Act
			countryCode = vtex.i18n.getCountryCode()

			# Assert
			expect(countryCode).toMatch('USA')

	describe 'based on a page that contains only the meta tags', ->

		beforeEach ->
			loadFixtures 'meta.html'
			# Reset variables
			$.extend(window.vtex.i18n, new window.vtex.VtexI18n())

		it 'should set the default locale based on the meta language tag', ->
			# Arrange

			# Act
			locale = vtex.i18n.getLocale()

			# Assert
			expect(locale).toMatch('en-US')

	describe 'based on a page that doesn\'t contain any useful information', ->

		beforeEach ->
			loadFixtures 'none.html'
			# Reset variables
			$.extend(window.vtex.i18n, new window.vtex.VtexI18n())

		it 'should set the default locale to pt-BR', ->
			# Arrange

			# Act
			locale = vtex.i18n.getLocale()

			# Assert
			expect(locale).toMatch('pt-BR')

		it 'should set the default countryCode to BRA', ->
			# Arrange

			# Act
			countryCode = vtex.i18n.getCountryCode()

			# Assert
			expect(countryCode).toMatch('BRA')

	describe 'callback', ->

		it 'should be called when locale is set', ->
			# Arrange
			foo = jasmine.createSpy('foo')
			newLocale = 'pt-BR'

			# Act
			vtex.i18n.setLocaleCallback(foo)
			vtex.i18n.setLocale(newLocale)

			# Assert
			expect(foo).toHaveBeenCalledWith(newLocale)

		it 'should be called when countryCode is set', ->
			# Arrange
			bar = jasmine.createSpy('bar')
			newCountryCode = 'BRA'

			# Act
			vtex.i18n.setCountryCodeCallback(bar)
			vtex.i18n.setCountryCode(newCountryCode)

			# Assert
			expect(bar).toHaveBeenCalledWith(newCountryCode)

	describe 'currency', ->

		it 'should return the selected currency by default', ->
			# Arrange

			# Act
			currency = vtex.i18n.getCurrency()

			# Assert
			expect(currency).toMatch(/R\$ /)

		it 'should return the specific currency if currency is set by user', ->
			# Arrange
			vtex.i18n.setCurrency('$')

			# Act
			currency = vtex.i18n.getCurrency()

			# Assert
			expect(currency).toMatch(/\$ /)

	describe 'decimal separator', ->

		it 'should return the selected decimal separator by default', ->
			# Arrange
			vtex.i18n.setCountryCode('BRA')

			# Act
			decimalSeparator = vtex.i18n.getDecimalSeparator()

			# Assert
			expect(decimalSeparator).toMatch(/\,/)

		it 'should return the specific decimal separator if countryCode is passed to function', ->
			# Arrange
			countryCode = 'USA'

			# Act
			decimalSeparator = vtex.i18n.getDecimalSeparator(countryCode)

			# Assert
			expect(decimalSeparator).toMatch(/\./)

	describe 'thousands separator', ->

		it 'should return the selected thousands separator by default', ->
			# Arrange
			vtex.i18n.setCountryCode('BRA')

			# Act
			decimalSeparator = vtex.i18n.getThousandsSeparator()

			# Assert
			expect(decimalSeparator).toMatch(/\./)

		it 'should return the specific decimal separator if countryCode is passed to function', ->
			# Arrange
			countryCode = 'USA'

			# Act
			decimalSeparator = vtex.i18n.getThousandsSeparator(countryCode)

			# Assert
			expect(decimalSeparator).toMatch(/\,/)