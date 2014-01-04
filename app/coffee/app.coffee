RecipeCtrl = ($scope) ->
  $scope.view = 'input'
  $scope.step = 0

  $scope.go = -> 
    $scope.steps = extractSteps $scope.recipeText
    console.log $scope.steps
    $scope.view = 'recipe'
  $scope.back = -> $scope.view = 'input'
  $scope.nextStep = -> $scope.step = $scope.step + 1
  $scope.previousStep = -> $scope.step = $scope.step - 1

  $scope.showInput = -> $scope.view == 'input'
  $scope.showRecipe = -> $scope.view == 'recipe'
  $scope.showStep = (n) -> $scope.step == n

  extractSteps = (text) ->
    _.chain(text.split '\n')
      .filter((s) -> !!s)
      .map((s) ->
        text: s
        timers: extractTimers(s)
      )
      .value()

  extractTimers = (text) -> 
    regexp = /(\w+)\s+for\s+(\d+)\s+((seconds?)|(minutes?)|(hours?))/g
    match = regexp.exec text
    while match?
      timer =
        verb: match[1]
        time: match[2]
        unit: match[3]
      match = regexp.exec text
      timer

root = exports ? this
root.RecipeCtrl = RecipeCtrl