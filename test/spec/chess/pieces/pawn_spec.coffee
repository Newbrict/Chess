describe 'Pawn', ->

	beforeEach ->
		@whitePawn = new Pawn true
		@whitePawn.hasMoved = true
		@blackPawn = new Pawn false
		@blackPawn.hasMoved = true
		@board = new Board

	it 'has a name', ->
		expect(@whitePawn.name).toBe 'Pawn'
		expect(@blackPawn.name).toBe 'Pawn'

	it 'has a point value', ->
		expect(typeof @whitePawn.value).toBe "number"
		expect(typeof @blackPawn.value).toBe "number"
		expect(@whitePawn.value).toBe 1
		expect(@blackPawn.value).toBe 1

	it "can only move forward one or two spaces if it's in original position ", ->
		@board.set 1, 1, @whitePawn
		moves = @board.getMoves 1, 1
		expect(moves).toContain [1, 2, "move"]
		expect(moves).toContain [1, 3, "move"]
		expect(moves.length).toBe 2

		@board.set 1, 6, @blackPawn
		moves = @board.getMoves 1, 6
		expect(moves).toContain [1, 5, "move"]
		expect(moves).toContain [1, 4, "move"]
		expect(moves.length).toBe 2

	it "can only move forward one space if not on original position", ->
		@board.set 1, 2, @whitePawn
		moves = @board.getMoves 1, 2
		expect(moves).toContain [1, 3, "move"]
		expect(moves.length).toBe 1

		@board.set 1, 5, @blackPawn
		moves = @board.getMoves 1, 5
		expect(moves).toContain [1, 4, "move"]
		expect(moves.length).toBe 1

	it 'can have its movement blocked', ->
		# Block directly in front of it vertically
		@board.set 1, 2, @blackPawn
		@board.set 1, 1, @whitePawn
		moves = @board.getMoves 1, 1
		expect(moves.length).toBe 0

		@board.set 1, 1, @whitePawn
		@board.set 1, 2, @blackPawn
		moves = @board.getMoves 1, 2
		expect(moves.length).toBe 0

		# Blocker two spaces in front of it
		@board.reset 1, 2
		@board.reset 1, 1
		@board.set 1, 3, @blackPawn
		@board.set 1, 1, @whitePawn

		moves = @board.getMoves 1, 1
		expect(moves).toContain [1, 2, "move"]
		expect(moves.length).toBe 1

		moves = @board.getMoves 1, 3
		expect(moves).toContain [1, 2, "move"]
		expect(moves.length).toBe 1

	it "can capture diagonally", ->
		# In front and to the left
		@board.set 1, 3, @blackPawn
		@board.set 2, 2, @whitePawn
		moves = @board.getMoves 2, 2
		expect(moves).toContain [1, 3, "capture"]

		# In front and to the right
		@board.set 3, 3, @blackPawn
		moves = @board.getMoves 2, 2
		expect(moves).toContain [3, 3, "capture"]

		# In front and to the right
		@board.reset 1, 3
		moves = @board.getMoves 3, 3
		expect(moves).toContain [2, 2, "capture"]

		# In front and to the left
		@board.set 4, 2, @whitePawn
		moves = @board.getMoves 3, 3
		expect(moves).toContain [4, 2, "capture"]
