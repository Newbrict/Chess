'use strict'

class @Knight extends Piece
	name: "Knight"
	value: 3
	blackSymbol: "\u265E"
	whiteSymbol: "\u2658"

	getMoves: (x,y,board) ->
		moves = []
		# loops over entire board, less efficient but easier to read
		for j in [0..7]
			for i in [0..7]
				xo = Math.abs (x - i)
				yo = Math.abs (y - j)
				if (xo == 1 && yo == 2) || (yo == 1 && xo == 2)
					if board.get(i,j).isBlank
						moves.push [i, j, "move"]
					else if board.get(i,j).isWhite != @isWhite
						moves.push [i, j, "capture"]

		return moves
