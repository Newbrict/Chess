describe 'Bishop', ->

	beforeEach ->
		@bish = new Bishop true
		@board = new Board

	it 'has a name', ->
		expect(@bish.name).toBe 'Bishop'

	it 'has a point value', ->
		expect(typeof @bish.value).toBe "number"
		expect(@bish.value).toBe 3

	it 'cannot move if blocked on all diagonals', ->
		@board.set 4, 4, @bish
		# bottom left
		@board.set 3, 3, "P"
		# top left
		@board.set 3, 5, "P"
		# top right
		@board.set 5, 5, "P"
		# bottom right
		@board.set 5, 3, "P"

		moves = @board.getMoves 4, 4
		expect(moves.length).toBe 0

	it 'can only move/capture diagonally', ->
		@board.set 4, 4, @bish
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
		expect(moves).toContain [3, 3, "capture"]
		expect(moves).toContain [5, 5, "capture"]
		expect(moves).toContain [5, 3, "capture"]
		expect(moves).toContain [3, 5, "capture"]
