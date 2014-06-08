class Rook extends Piece
	name: "Rook"
	value: 5
	blackSymbol: "\u265C"
	whiteSymbol: "\u2656"

	getMoves: (x,y,board) ->
		moves = []
		for j in [0..7]
			for i in [0..7]
				if board.get(i,j).isWhite != @isWhite or board.get(i,j).isBlank
					if board.clearStraight(x,y,i,j)
						moves.push( [i,j] )
		return moves

@Rook = Rook
