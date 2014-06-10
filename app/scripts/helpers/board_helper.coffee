# a8 to [1,8]
@anToxy = (an) ->

	x = an[0].charCodeAt 0
	x = x - 96

	y = an[1]

	return [x,y]

# 1, 8 to a8
@xyToan = (x,y) ->
	return (String.fromCharCode (x+96)) + y

@pieceFromChar = (c) ->
	switch c
		when "p" then new Pawn   false
		when "r" then new Rook   false
		when "n" then new Knight false
		when "b" then new Bishop false
		when "q" then new Queen  false
		when "k" then new King   false
		when "P" then new Pawn   true
		when "R" then new Rook   true
		when "N" then new Knight true
		when "B" then new Bishop true
		when "Q" then new Queen  true
		when "K" then new King   true
		else new BlankPiece

