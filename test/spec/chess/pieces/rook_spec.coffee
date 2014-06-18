describe 'Rook', ->

	beforeEach ->
		@rook = new Rook true
		@board = new Board

	it 'has a name', ->
		expect(@rook.name).toBe 'Rook'

	it 'has a point value', ->
		expect(typeof @rook.value).toBe "number"
		expect(@rook.value).toBe 5

	it 'cannot move if blocked on all horizontals', ->
		@board.set 4, 4, @rook
		# left
		@board.set 3, 4, "P"
		# bottom
		@board.set 4, 3, "P"
		# top
		@board.set 4, 5, "P"
		# right
		@board.set 5, 4, "P"

		moves = @board.getMoves 4, 4
		expect(moves.length).toBe 0

	it 'can only move/capture horizontally', ->
		@board.set 4, 4, @rook
		# bottom left
		@board.set 3, 3, "p"
		# left
		@board.set 3, 4, "p"
		# top left
		@board.set 3, 5, "p"
		# top
		@board.set 4, 5, "p"
		# top right
		@board.set 5, 5, "p"
		# right
		@board.set 5, 4, "p"
		# bottom right
		@board.set 5, 3, "p"
		# bottom
		@board.set 4, 3, "p"

		moves = @board.getMoves 4, 4
		expect(moves.length).toBe 4
		expect(moves).toContain [3, 4, "capture"]
		expect(moves).toContain [5, 4, "capture"]
		expect(moves).toContain [4, 3, "capture"]
		expect(moves).toContain [4, 5, "capture"]
