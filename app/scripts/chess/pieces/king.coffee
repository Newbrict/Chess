'use strict'

class @King extends Piece
	name: "King"
	value: 137
	blackSymbol: "\u265A"
	whiteSymbol: "\u2654"

	getMoves: (x,y,board) ->
		moves = []

		# castling
		unless @hasMoved
			# king can't be in check
			unless board.inCheck(4, y, @isWhite)
				# left side
				if board.clearStraight(x,y,0,y)
					if not board.get(0,y).hasMoved and board.get(0,y) instanceof Rook
						# cannot castle through a check
						unless board.inCheck(1, y, @isWhite) ||
						board.inCheck(2, y, @isWhite) ||
						board.inCheck(3, y, @isWhite)
							moves.push [2,y, "castle"]

				# right side
				if board.clearStraight(x,y,7,y)
					if not board.get(0,y).hasMoved and board.get(0,y) instanceof Rook
						# cannot castle through a check
						unless board.inCheck(5, y, @isWhite) ||
						board.inCheck(6, y, @isWhite)
							moves.push [6,y, "castle"]

		# regular moves
		for j in [0..7]
			for i in [0..7]
				# current square is not a move
				if i == x and j == y
					continue

				# at this stage we have the radius around the king
				if Math.abs(i-x) < 2 and Math.abs(j-y) < 2
					# simple moves
					if board.get(i,j).isBlank
							unless board.inCheck(i,j, @isWhite)
								moves.push [i,j,"move"]

					# captures
					else if board.get(i,j).isWhite != @isWhite
							unless board.inCheck(i,j, @isWhite)
								moves.push [i,j,"capture"]
		return moves
