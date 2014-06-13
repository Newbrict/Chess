describe 'Queen', ->

	beforeEach ->
		@queen = new Queen true
		@board = new Board

	it 'has a name', ->
		expect(@queen.name).toBe 'Queen'

	it 'has a point value', ->
		expect(typeof @queen.value).toBe "number"
		expect(@queen.value).toBe 9

	it 'cannot move if blocked fully', ->
		@board.set 4, 4, @queen
		# bottom left
		@board.set 3, 3, "P"
		# left
		@board.set 3, 4, "P"
		# top left
		@board.set 3, 5, "P"
		# top
		@board.set 4, 5, "P"
		# top right
		@board.set 5, 5, "P"
		# right
		@board.set 5, 4, "P"
		# bottom right
		@board.set 5, 3, "P"
		# bottom
		@board.set 4, 3, "P"

		moves = @board.getMoves 4, 4
		expect(moves.length).toBe 0

	it 'can capture diagonally and horizontally', ->
		@board.set 4, 4, @queen
		# bottom left
		@board.set 2, 2, "p"
		# left
		@board.set 2, 4, "p"
		# top left
		@board.set 2, 6, "p"
		# top
		@board.set 4, 6, "p"
		# top right
		@board.set 6, 6, "p"
		# right
		@board.set 6, 4, "p"
		# bottom right
		@board.set 6, 2, "p"
		# bottom
		@board.set 4, 2, "p"

		moves = @board.getMoves 4, 4
		expect(moves.length).toBe 16
		expect(moves).toContain [2, 2]
		expect(moves).toContain [6, 6]
		expect(moves).toContain [6, 2]
		expect(moves).toContain [2, 6]
		expect(moves).toContain [2, 4]
		expect(moves).toContain [6, 4]
		expect(moves).toContain [4, 2]
		expect(moves).toContain [4, 6]
