'use strict'

class @Bishop extends Piece
	name: "Bishop"
	value: 3
	blackSymbol: "\u265D"
	whiteSymbol: "\u2657"

	getMoves: (x,y,board) ->
		moves = []
		for j in [0..7]
			for i in [0..7]
				if board.clearDiagonal(x, y, i, j)
					if board.get(i,j).isBlank
						moves.push [i, j, "move"]
					else if board.get(i,j).isWhite != @isWhite
						moves.push [i, j, "capture"]
		return moves
