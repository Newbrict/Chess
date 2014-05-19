'use strict'

# eventually Piece should have a canMove
class Piece
	type: ->
		@name

	pointValue: ->
		@value

class BlankPiece extends Piece
	name: ""
	value: 0

class Pawn extends Piece
	name: "Pawn"
	value: 1

class Bishop extends Piece
	name: "Bishop"
	value: 3

class Knight extends Piece
	name: "Knight"
	value: 3

class Rook extends Piece
	name: "Rook"
	value: 5

class Queen extends Piece
	name: "Queen"
	value: 9

class King extends Piece
	name: "King"
	value: 137



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
	for x in [1..8]
		for y in [1..8]
			new BlankPiece

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





# some tests
#console.log anToxy "a8"
#console.log xyToan 1, 8

myBoard = new Board
myBoard.set("a2", new Knight)
myBoard.set(1,1, new King)
console.log myBoard.get(1,2)
console.log myBoard.get("a1")

#myPiece = new Pawn
#console.log myPiece.pointValue()
