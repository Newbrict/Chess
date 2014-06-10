describe 'Pawn', ->

	beforeEach ->
		@whitePawn = new Pawn true
		@whitePawn.hasMoved = true
		@blackPawn = new Pawn false
		@blackPawn.hasMoved = true
		@board = new Board

	it 'has a type', ->
		expect(@whitePawn.type()).toBe 'Pawn'
		expect(@blackPawn.type()).toBe 'Pawn'

	it 'has a point value', ->
		expect(typeof @whitePawn.pointValue()).toBe "number"
		expect(typeof @blackPawn.pointValue()).toBe "number"

	it "can only move forward one or two spaces if it hasn't moved yet", ->
		@whitePawn.hasMoved = false
		@board.set 1, 1, @whitePawn
		moves = @board.getMoves 1, 1
		expect(moves).toContain [1, 2]
		expect(moves).toContain [1, 3]
		expect(moves.length).toBe 2
		expect(@whitePawn.hasMoved).toBe false

		@blackPawn.hasMoved = false
		@board.set 1, 4, @blackPawn
		moves = @board.getMoves 1, 1
		expect(moves).toContain [1, 3]
		expect(moves).toContain [1, 2]
		expect(moves.length).toBe 2
		expect(@blackPawn.hasMoved).toBe false

	it "can only move forward one space if it has moved", ->
		@board.set 1, 1, @whitePawn
		moves = @board.getMoves 1, 1
		expect(moves).toContain [1, 2]
		expect(moves.length).toBe 1

		@board.set 1, 1, @blackPawn
		moves = @board.getMoves 1, 1
		expect(moves).toContain [1, 0]
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
		expect(moves).toContain [1, 2]
		expect(moves.length).toBe 1

		moves = @board.getMoves 1, 3
		expect(moves).toContain [1, 2]
		expect(moves.length).toBe 1

	it "can capture diagonally", ->
		# In front and to the left
		@board.set 1, 3, @blackPawn
		@board.set 2, 2, @whitePawn
		moves = @board.getMoves 2, 2
		expect(moves).toContain([1,3])

		# In front and to the right
		@board.set 3, 3, @blackPawn
		moves = @board.getMoves 2, 2
		expect(moves).toContain([3,3])

		# In front and to the right
		@board.reset 1, 3
		moves = @board.getMoves 3, 3
		expect(moves).toContain([2,2])

		# In front and to the left
		@board.set 4, 2, @whitePawn
		moves = @board.getMoves 3, 3
		expect(moves).toContain([4,2])
