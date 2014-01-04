RecipeCtrl = ($scope) ->
  $scope.view = 'input'
  $scope.step = 0

  $scope.go = -> 
    $scope.steps = _.chain($scope.recipeText.split '\n').filter((s) -> !!s).value()
    $scope.view = 'recipe'
  $scope.back = -> $scope.view = 'input'
  $scope.nextStep = -> $scope.step = $scope.step + 1
  $scope.previousStep = -> $scope.step = $scope.step - 1

  $scope.showInput = -> $scope.view == 'input'
  $scope.showRecipe = -> $scope.view == 'recipe'
  $scope.showStep = (n) -> $scope.step == n

root = exports ? this
root.RecipeCtrl = RecipeCtrl