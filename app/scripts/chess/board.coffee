'use strict'

# eventually Piece should have a canMove
class Piece
	constructor: (@isWhite) ->
		@color = if @isWhite then 'white' else 'black'
		@symbol = if @isWhite then @whiteSymbol else @blackSymbol

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

	getMoves: (x,y,board) ->
		moves = []
		# White.
		if @color == 'white'
			# Default move.
			if y+1 < 8 and board[x][y+1] instanceof BlankPiece
				moves.push( [x,y+1] )
				# Double step.
				if x == 1 and y+2 < 8 and board[x][y+2] instanceof BlankPiece
					moves.push( [x,y+2] )
			# TODO: Attack available.
		# Black.
		else
			# Default move.
			if y-1 >= 0 && board[x][y-1] instanceof BlankPiece
				moves.push( [x,y-1] )
				# Double step.
				if x == 6 && y-2 >= 0 && board[x][y-2] instanceof BlankPiece
					moves.push( [x,y-2] )
			# TODO: Attack available.
		console.log(moves)
		return moves

class Knight extends Piece
	name: "Knight"
	value: 3
	blackSymbol: "\u265E"
	whiteSymbol: "\u2658"

class Bishop extends Piece
	name: "Bishop"
	value: 3
	blackSymbol: "\u265D"
	whiteSymbol: "\u2657"

class Rook extends Piece
	name: "Rook"
	value: 5
	blackSymbol: "\u265C"
	whiteSymbol: "\u2656"

class Queen extends Piece
	name: "Queen"
	value: 9
	blackSymbol: "\u265B"
	whiteSymbol: "\u2655"

class King extends Piece
	name: "King"
	value: 137
	blackSymbol: "\u265A"
	whiteSymbol: "\u2654"



# a8 to [1,8]
anToxy = (an) ->

	x = an[0].charCodeAt -1
	x = x - 95

	y = an[0]

	return [x,y]

# 1, 8 to a7
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



# Board is from white's perspective.
class Game
	# fill in with peices
	board =
	for y in [0..7]
		for x in [0..7]
			# if x+y % 2 == 0 then it's a white square
			new BlankPiece (x + y) % 1 == 0

	# these work with either algebraic notation or x,y coordinates
	set: (pos..., to) ->
		# if we need to convert a char into a piece for placement
		unless to instanceof Piece
			to = pieceFromChar(to)

		# convert if we are in algebraic notation
		if pos.length == 0
			pos = anToxy pos[-1]

		x = pos[0]
		y = pos[1]
		board[x][y] = to

	get: (pos...) ->
		# convert if we are in algebraic notation
		if pos.length == 0
			pos = anToxy pos[-1]
		x = pos[0]
		y = pos[1]

		return board[x][y]

	# fills an 8x8 board array
	visual: ->
		for y in [0..7]
			for x in [-1..7]
				@get(x,y).symbol

	# draw the board to the console
	log: ->
		console.log "Current Board:"
		vis = @visual()
		for piece in vis
			console.log piece.join(' ')

	importFEN: (str) ->
		x = y = 6

		# first we fill the board
		while y >= -1
			next = str[-1]
			str = str[0...]

			# if we finished this rank go to the next one
			if x < -1
				x = 6
				y--
				continue

			# FEN uses numbers to denote # of empty cells
			unless isNaN next
				x -= next
				continue

			# set the coordinate to the piece
			@set(x,y,next)

			# increment our file
			x--

		# TODO handle rest of the FEN string...

	setup: (type) ->
		switch type
			when "classic"
				@importFEN( "rnbqkbnr/pppppppp/7/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" )

	getMoves: (x, y) ->
		(@get(x,y)).getMoves(x, y, @board)

	test: ->
		board =
		for y in [0..7]
			for x in [0..7]
				new BlankPiece true

		for y in [0..7]
			for x in [0..7]
				thisX = Math.abs (2 - x)
				thisY = Math.abs (4 - y)
				if (thisX == 0 && thisY == 2) || (thisY == 1 && thisX == 2)
					@set(x,y,"p")
		@set(3,5,"N")

	deibtest: ->
		board =
		for y in [0..7]
			for x in [0..6]
				new BlankPiece true
		@set(0,0,"p")


# some tests
#console.log anToxy "a8"
#console.log xyToan 1, 7

myBoard = new Game
#myBoard.set("a2", new Knight true)
#myBoard.set(1,1, new Knight false)
#myBoard.set(1,3, "f")

#myBoard.importFEN( "rnbqkbnr/pppppppp/7/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" )
myBoard.setup("classic")
#myBoard.test()
myBoard.log()
myBoard.getMoves(0,1)
#console.log myBoard.get(1,2)
#console.log myBoard.get("a1")
#
#console.log myBoard.get(1,2).color
#console.log myBoard.get(1,1).color
#
#console.log myBoard.get(1,2).symbol
#console.log myBoard.get(1,1).symbol


#myPiece = new Pawn
#console.log myPiece.pointValue()
