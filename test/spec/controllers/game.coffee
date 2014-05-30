
describe 'Chess Game', ->
	myGame = new Game()

	it 'can create a white pawn', ->
		myGame.set(0,0,"p")
		result = myGame.get(0,0) instance of Pawn
		expect(result).toBe true
