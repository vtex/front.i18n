jasmine.getFixtures().fixturesPath = 'base/build/spec/fixtures'
jasmine.getJSONFixtures().fixturesPath = 'base/build/spec/fixtures'

describe 'Locale Selector', ->

	it 'should have its dependencies to be defined', ->
		expect($).toBeDefined()
		expect(i18n).toBeDefined()
		expect(vtex.i18n).toBeDefined()

	describe 'dictionaries', ->

		beforeEach ->
			loadFixtures "translation-en-US.js"
			loadFixtures "translation-pt-BR.js"

		it 'should load based on its locale', ->
			# Arrange
			vtex.i18n.setLocale('en-US')
			vtex.i18n.init()

			# Act
			translation = i18n.t('foo')
			
			# Assert
			expect(translation).toMatch('english bar')

		it 'should load pt-BR by default if dictionary it\'s not found', ->
			# Arrange
			vtex.i18n.setLocale('klingon')
			vtex.i18n.init()

			# Act
			translation = i18n.t('foo')

			# Assert
			expect(translation).toMatch('bar portugues')


	
				




	