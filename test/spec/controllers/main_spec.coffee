'use strict'

describe 'Controller: MainCtrl', ->

  # load the controller's module
  beforeEach module 'chessApp'

  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl', {
      $scope: scope
    }

  it 'should create an instance of the game', ->
    expect(scope.game instanceof Game).toBe true
