describe 'Piece', ->

	beforeEach ->
		@piece = new Piece true

	it 'has a type', ->
		expect(@piece.type).toBeDefined()

	it 'has a point value', ->
		expect(@piece.pointValue).toBeDefined()

	it 'correctly identifies its color', ->
		expect(@piece.color).toBe 'white'
		expect((new Piece false).color).toBe 'black'

	it "knows that it's not blank", ->
		expect(@piece.isBlank).toBe false

	it "knows that it hasn't moved", ->
		expect(@piece.hasMoved).toBe false
