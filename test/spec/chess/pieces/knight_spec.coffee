describe 'Knight', ->

	beforeEach ->
		@knight = new Knight true
		@board = new Board

	it 'has a name', ->
		expect(@knight.name).toBe 'Knight'

	it 'has a point value', ->
		expect(typeof @knight.value).toBe "number"
		expect(@knight.value).toBe 3

	it "can can move in 8 directions and hop over pieces", ->

		# TO CAPTURE
		# bottom left
		@board.set 3, 2, "p"
		# bottom right
		@board.set 5, 2, "p"

		# left bottom
		@board.set 2, 3, "p"
		# left top
		@board.set 2, 5, "p"

		# top left
		@board.set 3, 6, "p"
		# top right
		@board.set 5, 6, "p"

		# right bottom
		@board.set 6, 3, "p"
		# right top
		@board.set 6, 5, "p"

		# TO SURROUND
		@board.set 5, 3, "P"
		@board.set 4, 3, "P"
		@board.set 3, 3, "P"

		@board.set 3, 4, "P"
		@board.set 5, 4, "P"

		@board.set 5, 5, "P"
		@board.set 4, 5, "P"
		@board.set 3, 5, "P"

		moves = @knight.getMoves 4, 4, @board

		expect(moves).toContain [3, 2, "capture"]
		expect(moves).toContain [5, 2, "capture"]
		expect(moves).toContain [2, 3, "capture"]
		expect(moves).toContain [2, 5, "capture"]
		expect(moves).toContain [3, 6, "capture"]
		expect(moves).toContain [5, 6, "capture"]
		expect(moves).toContain [6, 3, "capture"]
		expect(moves).toContain [6, 5, "capture"]

		expect(moves.length).toBe 8
