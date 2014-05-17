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

# Board is from white's perspective.
class Board
	# fill in with peices
	board =
	for x in [1..8]
		for y in [1..8]
			new BlankPiece

	# rank, file
	set: (x, y, to) ->
		board[x][y] = to

	# rank, file
	get: (x, y) ->
		board[x][y]

# some tests
myBoard = new Board
myBoard.set(1,2, new Knight)
console.log myBoard.get(1,2)
console.log myBoard.get(1,1)

myPiece = new Pawn
console.log myPiece.pointValue()
