describe 'King', ->

	beforeEach ->
		# everything will be done with white king as
		# color shouldn't make a difference
		@king = new King true
		@board = new Board

	it 'has a type', ->
		expect(@king.type()).toBe 'King'

	it 'has a point value', ->
		expect(typeof @king.pointValue()).toBe "number"
		expect(@king.pointValue()).toBe 137

	it "can can move in 8 directions", ->
		moves = @king.getMoves 4, 4, @board
		# bottom
		expect(moves).toContain [4, 3]
		# bottom left
		expect(moves).toContain [3, 3]
		# left
		expect(moves).toContain [3, 4]
		# top left
		expect(moves).toContain [3, 5]
		# top
		expect(moves).toContain [4, 5]
		# top right
		expect(moves).toContain [5, 5]
		# right
		expect(moves).toContain [5, 4]

		expect(moves.length).toBe 8

	it "can be put in check", ->
		# black queen
		@board.set 1, 2, "q"
		@board.set 2, 1, @king
		moves = @board.getMoves 2, 1
		expect(@board.inCheck(2, 1, @king.isWhite)).toBe true
		expect(@board.inCheckMate(2, 1, @king.isWhite)).toBe false
		expect(moves).toContain [2, 0]
		expect(moves).toContain [3, 1]
		expect(moves).toContain [1, 2]
		expect(moves.length).toBe 3

	it "can be put in check mate", ->
		# black queens
		@board.set 1, 2, "q"
		@board.set 2, 2, "q"
		@board.set 2, 1, @king
		moves = @board.getMoves 2, 1
		expect(@board.inCheck(2, 1, @king.isWhite)).toBe true
		expect(@board.inCheckMate(2, 1, @king.isWhite)).toBe true
		expect(moves.length).toBe 0
