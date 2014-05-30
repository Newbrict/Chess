'use strict'

# eventually Piece should have a canMove
class Piece
	constructor: (@isWhite) ->
		@color = if @isWhite then 'white' else 'black'
		@symbol = if @isWhite then @whiteSymbol else @blackSymbol
		@hasMoved = false

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
		# TODO: Implement en passant and pawn conversion.
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
			if not (enemy instanceof BlankPiece)
				if @color != enemy.color
					moves.push( [x-1, y+movement] )
		if game.inBounds( x+1, y+movement )
			enemy = game.get( x+1, y+movement )
			if not (enemy instanceof BlankPiece)
				if @color != enemy.color
					moves.push( [x+1, y+movement] )

		# DEBUG
		i = 0
		while i < moves.length
			console.log( moves[i] )
			i++
		return moves

class Knight extends Piece
	name: "Knight"
	value: 3
	blackSymbol: "\u265E"
	whiteSymbol: "\u2658"

	getMoves: (x,y,game) ->
		moves = []
		# loops over entire board, less efficient but easier to read
		# x and y for board
		for yb in [0..7]
			for xb in [0..7]
				unless game.get(xb,yb).isWhite == @isWhite
					# x and y offsets
					xo = Math.abs (x - xb)
					yo = Math.abs (y - yb)
					if (xo == 1 && yo == 2) || (yo == 1 && xo == 2)
						moves.push( [xb,yb] )

		return moves

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



# 0,0 on board is from white's perspective.
class Game
	# fill in with peices
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

	get: (x, y) ->
		return @board[x][y]

	# move 1 to 2
	move: (x1, y1, x2, y2) ->
		# TODO capture logic / points

		# move the piece and set flags
		p = @get(x1, y1)
		p.hasMoved = true
		@set(x2, y2, p)

		# clear the piece's old position
		@set(x1, y1, new BlankPiece)

	inBounds: (x, y) ->
		return (x >= 0 and y >= 0) and (x < 8 and y < 8)

	# fills an 8x8 board array
	visual: ->
		for y in [0..7]
			for x in [0..7]
				@get(x,y).symbol

	# draw the board to the console
	log: ->
		console.log "Current Board:"
		vis = @visual()
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
			@set(x,y,next)

			# increment our file
			x--

		# TODO handle rest of the FEN string...

	setup: (type) ->
		switch type
			when "classic"
				@importFEN( "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" )

	getMoves: (x, y) ->
		(@get(x,y)).getMoves( x, y, this )

	test: ->
		@board =
		for y in [0..7]
			for x in [0..7]
				new BlankPiece true

		@set(4,4,"n")
		@set(3,2,"K")
		@set(2,3,"k")
		moves = @getMoves(4,4)
		for xy in moves
			@set(xy[0], xy[1], "p")


	deibtest: ->
		@board =
		for y in [0..7]
			for x in [0..6]
				new BlankPiece true
		@set(0,0,"p")


# some tests
#console.log anToxy "a8"
#console.log xyToan 1, 8

myGame = new Game
#myGame.set("a2", new Knight true)
#myGame.set(1,1, new Knight false)
#myGame.set(1,3, "f")

#myGame.importFEN( "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" )
myGame.setup("classic")
myGame.set(4,2,"p")
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
