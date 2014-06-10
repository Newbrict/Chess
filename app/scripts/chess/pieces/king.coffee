'use strict'

class @King extends Piece
	name: "King"
	value: 137
	blackSymbol: "\u265A"
	whiteSymbol: "\u2654"

	getMoves: (x,y,board) ->
		moves = []
		for j in [0..7]
			for i in [0..7]
				# current square is not a move
				if i == x and j == y
					continue

				if board.get(i,j).isWhite != @isWhite or board.get(i,j).isBlank
					if Math.abs(i-x) < 2 and Math.abs(j-y) < 2
						# at this stage we have the radius around the king
						unless board.inCheck(i,j, @isWhite)
							moves.push( [i,j] )
		return moves
