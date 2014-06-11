describe 'Bishop', ->

	beforeEach ->
		@bish = new Bishop true
		@board = new Board

	it 'has a name', ->
		expect(@bish.name).toBe 'Bishop'

	it 'has a point value', ->
		expect(typeof @bish.value).toBe "number"
		expect(@bish.value).toBe 3
