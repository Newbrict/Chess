class Pawn extends Piece
	name: "Pawn"
	value: 1
	blackSymbol: "\u265F"
	whiteSymbol: "\u2659"

	getMoves: (x,y,game) ->
		moves = []
		# Constant that represents which direction pawns move in.
		movement = 1
		if @color == 'black'
			movement = -1

		# Default move.
		if y+movement < 8 and game.get( x, y+movement ) instanceof BlankPiece
			moves.push( [x,y+movement] )
			# Double step.
			if not @hasMoved
				if y+(2*movement) < 8 and game.get( x, y+(2*movement) ) instanceof BlankPiece
					moves.push( [x,y+(2*movement)] )
		# Check if the pawn can capture a piece.
		if game.inBounds( x-1, y+movement )
			enemy = game.get( x-1, y+movement )
			if not (enemy instanceof BlankPiece) and @color != enemy.color
				moves.push( [x-1, y+movement] )
		if game.inBounds( x+1, y+movement )
			enemy = game.get( x+1, y+movement )
			if not (enemy instanceof BlankPiece) and @color != enemy.color
				moves.push( [x+1, y+movement] )

		return moves

@Pawn = Pawn
