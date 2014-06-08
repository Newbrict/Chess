class @Queen extends Piece
	name: "Queen"
	value: 9
	blackSymbol: "\u265B"
	whiteSymbol: "\u2655"

	getMoves: (x,y,board) ->
		moves = []
		for j in [0..7]
			for i in [0..7]
				if board.get(i,j).isWhite != @isWhite or board.get(i,j).isBlank
					if board.clearStraight(x,y,i,j) or board.clearDiagonal(x,y,i,j)
						moves.push( [i,j] )
		return moves
