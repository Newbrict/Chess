'use strict'

class @Queen extends Piece
	name: "Queen"
	value: 9
	blackSymbol: "\u265B"
	whiteSymbol: "\u2655"

	getMoves: (x,y,board) ->
		moves = []
		for j in [0..7]
			for i in [0..7]

				if board.clearStraight(x,y,i,j) or board.clearDiagonal(x,y,i,j)
					if board.get(i,j).isBlank
						moves.push [i, j, "move"]
					else if board.get(i,j).isWhite != @isWhite
						moves.push [i, j, "capture"]

		return moves
