'use strict'

class @Rook extends Piece
	name: "Rook"
	value: 5
	blackSymbol: "\u265C"
	whiteSymbol: "\u2656"

	getMoves: (x,y,board) ->
		moves = []
		for j in [0..7]
			for i in [0..7]
				if board.clearStraight(x,y,i,j)
					if board.get(i,j).isBlank
						moves.push [i, j, "move"]
					else if board.get(i,j).isWhite != @isWhite
						moves.push [i, j, "capture"]
		return moves
