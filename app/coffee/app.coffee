RecipeCtrl = ($scope) ->
  $scope.view = 'input'

  $scope.go = -> 
    $scope.steps = _.chain($scope.recipeText.split '\n')
        .filter((s) -> !!s)
        .value()
    $scope.view = 'recipe'
  $scope.back = -> $scope.view = 'input'
  $scope.showInput = -> $scope.view == 'input'
  $scope.showRecipe = -> $scope.view == 'recipe'

root = exports ? this
root.RecipeCtrl = RecipeCtrl