describe 'Pawn', ->

	beforeEach ->
		@whitePawn = new Pawn true
		@blackPawn = new Pawn true
		@board = new Board

	it 'has a type', ->
		expect(@whitePawn.type()).toBe 'Pawn'
		expect(@blackPawn.type()).toBe 'Pawn'

	it 'has a point value', ->
		expect(typeof @whitePawn.pointValue()).toBe "number"
		expect(typeof @blackPawn.pointValue()).toBe "number"

	it "can only move forward one or two spaces if it hasn't moved yet", ->
		moves = @whitePawn.getMoves 1, 1, @board
		expect(moves).toContain [1, 2]
		expect(moves).toContain [1, 3]
		expect(moves.length).toBe 2
		expect(@whitePawn.hasMoved).toBe false

		moves = @blackPawn.getMoves 1, 1, @board
		expect(moves).toContain [1, 2]
		expect(moves).toContain [1, 3]
		expect(moves.length).toBe 2
		expect(@blackPawn.hasMoved).toBe false

	it "can only move forward one or two spaces if it has moved", ->
		@whitePawn.hasMoved = true
		moves = @whitePawn.getMoves 1, 1, @board
		expect(moves).toContain [1, 2]
		expect(moves.length).toBe 1

		@blackPawn.hasMoved = true
		moves = @blackPawn.getMoves 1, 1, @board
		expect(moves).toContain [1, 2]
		expect(moves.length).toBe 1

	it 'can have its movement blocked', ->
		# Block directly in front of it vertically
		@board.set 1, 2, @blackPawn
		moves = @whitePawn.getMoves 1, 1, @board
		expect(moves.length).toBe 0

		@board.set 1, 2, @whitePawn
		moves = @blackPawn.getMoves 1, 1, @board
		expect(moves.length).toBe 0

		# Blocker two spaces in front of it
		@board.set 1, 2, (new BlankPiece)
		@board.set 1, 3, @blackPawn
		moves = @whitePawn.getMoves 1, 1, @board
		expect(moves).toContain [1, 2]
		expect(moves.length).toBe 1

		@board.set 1, 3, @whitePawn
		moves = @blackPawn.getMoves 1, 1, @board
		expect(moves).toContain [1, 2]
		expect(moves.length).toBe 1
