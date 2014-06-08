class Piece
	constructor: (@isWhite) ->
		@color = if @isWhite then 'white' else 'black'
		@symbol = if @isWhite then @whiteSymbol else @blackSymbol
		@hasMoved = false
		@isBlank = @ instanceof BlankPiece

	type: ->
		@name

	pointValue: ->
		@value

@Piece = Piece
