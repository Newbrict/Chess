'use strict'

###############################################################################
# Board Class #################################################################
###############################################################################

# 0,0 on board is from white's perspective.
class Board
	# fill in with peices
	#TODO eventually give this an x and y size as constructor arg
	constructor: ->
		@board =
		for y in [0..7]
			for x in [0..7]
				# if x+y % 2 == 0 then it's a white square
				new BlankPiece (x + y) % 2 == 0

	# these work with either algebraic notation or x,y coordinates
	set: (x, y, to) ->
		# if we need to convert a char into a piece for placement
		unless to instanceof Piece
			to = pieceFromChar(to)

		@board[x][y] = to

	reset: (x, y) ->
		@board[x][y] = new BlankPiece (x + y) % 2 == 0


	get: (x, y) ->
		return @board[x][y]

	# move 1 to 2
	move: (x1, y1, x2, y2) ->

		# move the piece and set flags
		p = @get(x1, y1)
		p.hasMoved = true
		@set(x2, y2, p)

		# clear the piece's old position
		@set(x1, y1, new BlankPiece)

	inBounds: (x, y) ->
		return (x >= 0 and y >= 0) and (x < 8 and y < 8)

	# fills an board array with symbols
	visual: ->
		for y in [0..7]
			for x in [0..7]
				@get(x,y).symbol

	clearDiagonal: (x1, y1, x2, y2) ->
		if (x1 == x2) and (y1 == y2)
			return false
		# Check if a 45-degree diagonal exists.
		if Math.abs( x1 - x2 ) != Math.abs( y1 - y2 )
			return false

		xMove = 0
		yMove = 0
		if ( x1 < x2 ) then xMove = 1 else xMove = -1
		if ( y1 < y2 ) then yMove = 1 else yMove = -1

		i = x1 + xMove
		j = y1 + yMove
		while not (i==x1 and j==y1) and not (i==x2 and j==y2)
			if not (@get( i, j ) instanceof BlankPiece)
				return false
			i += xMove
			j += yMove

		return true


	clearStraight: (x1, y1, x2, y2) ->
		# Two tiles are not in straight lines if they are the same tile or
		# if not one of the coordinates is the same
		if (x1 == x2 and y1 == y2) or (x1 != x2 and y1 != y2)
			return false

		xMove = 0
		yMove = 0
		if x1 == x2
			if y1 < y2 then yMove = 1 else yMove = -1
		else
			if x1 < x2 then xMove = 1 else xMove = -1

		i = x1 + xMove
		j = y1 + yMove
		while not (i==x1 and j==y1) and not (i==x2 and j==y2)
			if not (@get( i, j ) instanceof BlankPiece)
				return false
			i += xMove
			j += yMove

		return true

	# takes x, y, and bool for isWhite
	inCheck: (x, y, white) ->

		# piece needs to be out of the way for this check
		tempPiece = @get(x,y)

		# clear the current square
		@reset(x,y)

		moves = []
		for j in [0..7]
			for i in [0..7]

				# skip the square in question
				if i == x and j == y
					continue

				# get moves of all non blank pieces of opposite color
				if @get(i,j).isWhite != white and !@get(i,j).isBlank
					moves = moves.concat(@getMoves(i,j))


		#put our piece back in place
		@set(x,y,tempPiece)

		# go through each move and check to see if we have an assailant
		for m in moves
			if m[0] == x and m[1] == y
				return true

		# phew, that was a close one, king.
		return false

	inCheckMate: (x, y, white) ->
		if @inCheck(x,y,white) and @getMoves(x, y).length == 0
			return true
		else
			return false

	getMoves: (x, y) ->

		# piece needs to be out of the way for this check
		tempPiece = @get(x,y)

		# clear the current square
		@reset(x,y)

		moves = tempPiece.getMoves(x, y, this)

		# put our piece back
		@set(x, y, tempPiece)

		return moves

@Board = Board
