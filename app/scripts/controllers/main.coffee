'use strict'

angular.module('chessApp')
	.controller 'MainCtrl', ($scope) ->
		$scope.game = new Game
		$scope.game.test()
		$scope.game.log()
