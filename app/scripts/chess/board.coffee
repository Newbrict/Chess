'use strict'

###############################################################################
# Piece Class #################################################################
###############################################################################

class Piece
	constructor: (@isWhite) ->
		@color = if @isWhite then 'white' else 'black'
		@symbol = if @isWhite then @whiteSymbol else @blackSymbol
		@hasMoved = false
		@isBlank = @ instanceof BlankPiece

	type: ->
		@name

	pointValue: ->
		@value

class BlankPiece extends Piece
	name: ""
	value: 0
	blackSymbol: "\u25A0"
	whiteSymbol: "\u25A1"

	getMoves: (x,y,board) ->
		return [[x,y]]

class Pawn extends Piece
	name: "Pawn"
	value: 1
	blackSymbol: "\u265F"
	whiteSymbol: "\u2659"

	getMoves: (x,y,game) ->
		moves = []
		# Constant that represents which direction pawns move in.
		movement = 1
		if @color == 'black'
			movement = -1

		# Default move.
		if y+movement < 8 and game.get( x, y+movement ) instanceof BlankPiece
			moves.push( [x,y+movement] )
			# Double step.
			if not @hasMoved
				if y+(2*movement) < 8 and game.get( x, y+(2*movement) ) instanceof BlankPiece
					moves.push( [x,y+(2*movement)] )
		# Check if the pawn can capture a piece.
		if game.inBounds( x-1, y+movement )
			enemy = game.get( x-1, y+movement )
			if not (enemy instanceof BlankPiece) and @color != enemy.color
				moves.push( [x-1, y+movement] )
		if game.inBounds( x+1, y+movement )
			enemy = game.get( x+1, y+movement )
			if not (enemy instanceof BlankPiece) and @color != enemy.color
				moves.push( [x+1, y+movement] )

		return moves

class Knight extends Piece
	name: "Knight"
	value: 3
	blackSymbol: "\u265E"
	whiteSymbol: "\u2658"

	getMoves: (x,y,board) ->
		moves = []
		# loops over entire board, less efficient but easier to read
		for j in [0..7]
			for i in [0..7]
				if board.get(i,j).isWhite != @isWhite or board.get(i,j).isBlank
					# x and y offsets
					xo = Math.abs (x - i)
					yo = Math.abs (y - j)
					if (xo == 1 && yo == 2) || (yo == 1 && xo == 2)
						moves.push([i,j])

		return moves

class Bishop extends Piece
	name: "Bishop"
	value: 3
	blackSymbol: "\u265D"
	whiteSymbol: "\u2657"

	getMoves: (x,y,board) ->
		moves = []
		for j in [0..7]
			for i in [0..7]
				if board.get(i,j).isWhite != @isWhite or board.get(i,j).isBlank
					if board.clearDiagonal(x, y, i, j)
						moves.push( [i,j] )
		return moves


class Rook extends Piece
	name: "Rook"
	value: 5
	blackSymbol: "\u265C"
	whiteSymbol: "\u2656"

	getMoves: (x,y,board) ->
		moves = []
		for j in [0..7]
			for i in [0..7]
				if board.get(i,j).isWhite != @isWhite or board.get(i,j).isBlank
					if board.clearStraight(x,y,i,j)
						moves.push( [i,j] )
		return moves

class Queen extends Piece
	name: "Queen"
	value: 9
	blackSymbol: "\u265B"
	whiteSymbol: "\u2655"

	getMoves: (x,y,board) ->
		moves = []
		for j in [0..7]
			for i in [0..7]
				if board.get(i,j).isWhite != @isWhite or board.get(i,j).isBlank
					if board.clearStraight(x,y,i,j) or board.clearDiagonal(x,y,i,j)
						moves.push( [i,j] )
		return moves

class King extends Piece
	name: "King"
	value: 137
	blackSymbol: "\u265A"
	whiteSymbol: "\u2654"

	getMoves: (x,y,board) ->
		moves = []
		for j in [0..7]
			for i in [0..7]
				if board.get(i,j).isWhite != @isWhite or board.get(i,j).isBlank
					if Math.abs(i-x) < 2 and Math.abs(j-y) < 2
						# at this stage we have the radius around the king
						unless board.inCheck(i,j, @isWhite)
							moves.push( [i,j] )
		return moves


###############################################################################
# Some Utilities ##############################################################
###############################################################################

# a8 to [1,8]
anToxy = (an) ->

	x = an[0].charCodeAt 0
	x = x - 96

	y = an[1]

	return [x,y]

# 1, 8 to a8
xyToan = (x,y) ->
	return (String.fromCharCode (x+96)) + y

pieceFromChar = (c) ->
	switch c
		when "p" then new Pawn   false
		when "r" then new Rook   false
		when "n" then new Knight false
		when "b" then new Bishop false
		when "q" then new Queen  false
		when "k" then new King   false
		when "P" then new Pawn   true
		when "R" then new Rook   true
		when "N" then new Knight true
		when "B" then new Bishop true
		when "Q" then new Queen  true
		when "K" then new King   true
		else new BlankPiece

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

###############################################################################
# Game Class ##################################################################
###############################################################################
class Game

	constructor: ->
		@board = new Board

	# draw the board to the console
	log: ->
		console.log "Current Board:"
		vis = @board.visual()
		for piece in vis
			console.log piece.join(' ')

	importFEN: (str) ->
		x = y = 7

		# first we fill the board
		while y >= 0
			next = str[0]
			str = str[1...]

			# if we finished this rank go to the next one
			if x < 0
				x = 7
				y--
				continue

			# FEN uses numbers to denote # of empty cells
			unless isNaN next
				x -= next
				continue

			# set the coordinate to the piece
			@board.set(x,y,next)

			# increment our file
			x--


	setup: (type) ->
		switch type
			when "classic"
				@importFEN( "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" )


	test: ->
		#@board =
		#for y in [0..7]
		#	for x in [0..7]
		#		new BlankPiece false

		@board.set(5,6,"r")
		@board.set(1,2,"n")
		@board.set(3,3,"q")
		@board.set(2,3,"q")
		@board.set(3,2,"K")

		check = @board.inCheck(3,2,true)
		checkMate = @board.inCheckMate(3,2,true)
		moves = @board.getMoves(3,2)
		for m	in moves
			@board.set(m[0], m[1], "p")
		console.log check + " " + checkMate


	deibTest: ->
		@board.set(4,4,"b")
		for o in @board.getMoves(4,4)
			console.log(o)


# some tests
#console.log anToxy "a8"
#console.log xyToan 1, 8

myGame = new Game
#myGame.set("a2", new Knight true)
#myGame.set(1,1, new Knight false)
#myGame.set(1,3, "f")

#myGame.importFEN( "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" )
#myGame.test()
myGame.test()
myGame.log()
#myGame.getMoves(4,4)
#console.log myGame.get(1,2)
#console.log myGame.get("a1")
#
#console.log myGame.get(1,2).color
#console.log myGame.get(1,1).color
#
#console.log myGame.get(1,2).symbol
#console.log myGame.get(1,1).symbol


#myPiece = new Pawn
#console.log myPiece.pointValue()

# deibTest
console.log("---------------")
deibGame = new Game
deibGame.deibTest()
deibGame.log()
