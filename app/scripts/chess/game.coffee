###############################################################################
# Game Class ##################################################################
###############################################################################
class @Game

	constructor: ->
		@board = new Board

	# draw the board to the console
	log: ->
		console.log "Current Board:"
		vis = @board.visual()
		for piece in vis
			console.log piece.join(' ')

	importFEN: (str) ->
		x = y = 7

		# first we fill the board
		while y >= 0
			next = str[0]
			str = str[1...]

			# if we finished this rank go to the next one
			if x < 0
				x = 7
				y--
				continue

			# FEN uses numbers to denote # of empty cells
			unless isNaN next
				x -= next
				continue

			# set the coordinate to the piece
			@board.set(x,y,next)

			# increment our file
			x--


	setup: (type) ->
		switch type
			when "classic"
				@importFEN( "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" )


	test: ->
		#@board =
		#for y in [0..7]
		#	for x in [0..7]
		#		new BlankPiece false

		@board.set(5,6,"r")
		@board.set(1,2,"n")
		@board.set(3,3,"q")
		@board.set(2,3,"q")
		@board.set(3,2,"K")

		check = @board.inCheck(3,2,true)
		checkMate = @board.inCheckMate(3,2,true)
		moves = @board.getMoves(3,2)
		for m	in moves
			@board.set(m[0], m[1], "p")
		console.log check + " " + checkMate


	deibTest: ->
		@board.set(4,4,"b")
		for o in @board.getMoves(4,4)
			console.log(o)
