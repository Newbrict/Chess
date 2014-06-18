'use strict'

class @Pawn extends Piece
	name: "Pawn"
	value: 1
	blackSymbol: "\u265F"
	whiteSymbol: "\u2659"

	getMoves: (x, y, board) ->
		moves = []
		# Constant that represents which direction pawns move in.
		dir = 1
		if !@isWhite
			dir = -1

		# Default move.
		if board.inBounds(0, y+dir) and board.get( x, y+dir ).isBlank
			moves.push( [x, y+dir, "move"] )
			# Double step.
			unless @hasMoved
				if board.inBounds(0, y+(2*dir)) and board.get( x, y+(2*dir) ).isBlank
					moves.push( [x, y+(2*dir), "move"] )


		# Check if the pawn can capture a piece.
		# to the left
		if board.inBounds( x-1, y+dir )
			enemy = board.get( x-1, y+dir )
			if !enemy.isBlank and enemy.isWhite != @isWhite
				moves.push( [x-1, y+dir, "capture"] )

		# to the right
		if board.inBounds( x+1, y+dir )
			enemy = board.get( x+1, y+dir )
			if !enemy.isBlank and enemy.isWhite != @isWhite
				moves.push( [x+1, y+dir, "capture"] )

		return moves
