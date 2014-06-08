class @Bishop extends Piece
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
