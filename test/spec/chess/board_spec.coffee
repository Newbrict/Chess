describe 'Board', ->

	beforeEach ->
		@board = new Board
		@xRange = [0..7]
		@yRange = [0..7]

	it "initializes a blank board", ->
		for y in @yRange
			for x in @xRange
				expect(@board.get(x,y) instanceof BlankPiece).toBe true

	it "can set squares", ->
		@board.set(4,4, "p")
		@board.set(5,5, new Pawn true)

		# verify position
		expect(@board.get(4,4) instanceof Pawn).toBe true
		expect(@board.get(5,5) instanceof Pawn).toBe true

		# verify color
		expect(@board.get(4,4).isWhite).toBe false
		expect(@board.get(5,5).isWhite).toBe true

	it "can move pieces", ->
		piece = new Pawn false
		@board.set(4,4, piece)
		expect(piece.hasMoved).toBe false
		@board.move(4,4,4,5)
		expect(piece.hasMoved).toBe true

	#	TODO not sure if I should put the diagonal/straight tests here as I may
	# want to move them into utilities eventually
