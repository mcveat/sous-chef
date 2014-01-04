RecipeCtrl = ($scope) ->
  $scope.go = -> console.log $scope.recipeText

root = exports ? this
root.RecipeCtrl = RecipeCtrl