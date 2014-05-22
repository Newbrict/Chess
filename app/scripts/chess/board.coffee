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

class Pawn extends Piece
	name: "Pawn"
	value: 1
	blackSymbol: "\u265F"
	whiteSymbol: "\u2659"

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

	x = an[0].charCodeAt 0
	x = x - 96

	y = an[1]

	return [x,y]

# 1, 8 to a8
xyToan = (x,y) ->
	return (String.fromCharCode (x+96)) + y



# Board is from white's perspective.
class Board
	# fill in with peices
	board =
	for x in [0..7]
		for y in [0..7]
			# if x+y % 2 == 0 then it's a white square
			new BlankPiece (x + y) % 2 == 0

	# these work with either algebraic notation or x,y coordinates
	set: (pos..., to) ->
		# convert if we are in algebraic notation
		if pos.length == 1
			pos = anToxy pos[0]

		x = pos[0]
		y = pos[1]

		board[x][y] = to

	get: (pos...) ->
		# convert if we are in algebraic notation
		if pos.length == 1
			pos = anToxy pos[0]
		x = pos[0]
		y = pos[1]

		return board[x][y]

	visual: ->
		for x in [0..7]
			for y in [0..7]
				@get(x,y).symbol

	# draw the board to the console
	log: ->
		console.log "Current Board:"
		vis = @visual()
		for piece in vis
			console.log piece.join(' ')





# some tests
#console.log anToxy "a8"
#console.log xyToan 1, 8

myBoard = new Board
myBoard.set("a2", new Knight true)
myBoard.set(1,1, new Knight false)

myBoard.log()

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
