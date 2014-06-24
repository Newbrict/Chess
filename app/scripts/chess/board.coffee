'use strict'

# 0,0 on board is from white's perspective.
class @Board
	# fill in with peices
	#TODO (maybe?) give this an x and y size as constructor arg
	constructor: ->
		@board =
		for y in [0..7]
			for x in [0..7]
				# if x+y % 2 == 0 then it's a white square
				new BlankPiece (x + y) % 2 == 0
		@history = []

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

	find: (piece) ->
		for j in [0..7]
			for i in [0..7]
				found = @get i, j
				if found.isWhite == piece.isWhite && found.constructor.name == piece.constructor.name
					return [i, j]
		return [-1, -1]

	# move 1 to 2
	move: (from, to) ->

		x1 = from[0]
		y1 = from[1]
		x2   = to[0]
		y2   = to[1]
		type = to[2]
		fromPiece = @get(x1,y1)
		toPiece   = @get(x2,y2)
		oldBoard = clone @board

		moves = @getMoves(x1, y1)
		if not containsPair(moves, x2, y2)
			return false

		# determine special moves AND write to history
		switch type
			when "move","capture"
				@history.push [x1,y1,x2,y2,type]
			when "castle"
				cRook = new Rook fromPiece.isWhite
				cRook.hasMoved = true
				if x2 == 2
					@reset 0, y2
					@set 3, y2, cRook
					@history.push [x1,y1,x2,y2,"long-castle"]
				if x2 == 6
					@reset 7, y2
					@set 5, y2, cRook
					@history.push [x1,y1,x2,y2,"short-castle"]

		# move the piece
		@set(x2, y2, fromPiece)

		# clear the piece's old position
		@reset x1, y1

		# check if the king is in check
		# first find the king coordinates
		kC = @find new King fromPiece.isWhite
		kx = kC[0]
		ky = kC[1]

		# now see if he's in check, if so revert the piece movement
		if kx >=0 and @inCheck kx, ky, fromPiece.isWhite
			@board = oldBoard
			@history.pop()
			return false
		else
			fromPiece.hasMoved = true

		return true


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
		if @inCheck(x, y, white) and @getMoves(x, y).length == 0
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
