'use strict'

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
		x = 0
		y = 7

		# first we fill the board
		while y >= 0
			next = str[0]
			str = str[1...]

			# if we finished this rank go to the next one
			if x > 7
				x = 0
				y--
				continue

			# FEN uses numbers to denote # of empty cells
			unless isNaN next
				x += next
				continue

			# set the coordinate to the piece
			@board.set(x,y,next)

			# increment our file
			x++


	setup: (type) ->
		switch type
			when "classic"
				@importFEN( "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" )


	test: ->
		#@board =
		#for y in [0..7]
		#	for x in [0..7]
		#		new BlankPiece false

		@board.set(2,2,"q")
		@board.set(1,2,"q")
		@board.set(2,1,"K")

		check = @board.inCheck(2,1,true)
		checkMate = @board.inCheckMate(2,1,true)
		moves = @board.getMoves(2,1)
		for m	in moves
			@board.set(m[0], m[1], "p")
		console.log check + " " + checkMate

# this should work god dammit
#myGame = new Game
#myGame.test()
#myGame.log()
