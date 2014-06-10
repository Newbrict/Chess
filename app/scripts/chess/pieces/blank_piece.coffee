'use strict'

class @BlankPiece extends Piece
	name: ""
	value: 0
	blackSymbol: "\u25A0"
	whiteSymbol: "\u25A1"

	getMoves: (x,y,board) ->
		return [[x,y]]
