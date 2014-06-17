describe 'King', ->

	beforeEach ->
		# everything will be done with white king as
		# color shouldn't make a difference
		@king = new King true
		@game = new Game
		@board = @game.board

	it 'has a name', ->
		expect(@king.name).toBe 'King'

	it 'has a point value', ->
		expect(typeof @king.value).toBe "number"
		expect(@king.value).toBe 137

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

	it "can castle only if he and rook hasn't moved", ->
		@game.setup("classic")

		# white king's position
		moves = @board.getMoves(4,0)
		expect(moves.length).toBe 0

		# black king's position
		moves = @board.getMoves(4,7)
		expect(moves.length).toBe 0

		# remove space on left of kings
		@board.reset(1,0)
		@board.reset(1,7)
		@board.reset(2,0)
		@board.reset(2,7)
		@board.reset(3,0)
		@board.reset(3,7)

		# remove space on right of kings
		@board.reset(5,0)
		@board.reset(5,7)
		@board.reset(6,0)
		@board.reset(6,7)

		# white king's position
		moves = @board.getMoves(4,0)
		expect(moves.length).toBe 4
		expect(moves).toContain [2,0]
		expect(moves).toContain [3,0]
		expect(moves).toContain [5,0]
		expect(moves).toContain [6,0]

		# black king's position
		moves = @board.getMoves(4,7)
		expect(moves.length).toBe 4
		expect(moves).toContain [2,7]
		expect(moves).toContain [3,7]
		expect(moves).toContain [5,7]
		expect(moves).toContain [6,7]

		# white king will do long castle, black will do short castle
		@board.move(4,0,2,0)
		@board.move(4,7,6,7)
		expect(@board.get(2,0).name).toBe "King"
		expect(@board.get(3,0).name).toBe "Rook"
		expect(@board.get(6,7).name).toBe "King"
		expect(@board.get(5,7).name).toBe "Rook"
