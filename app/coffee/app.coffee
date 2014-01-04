RecipeCtrl = ($scope) ->
  $scope.view = 'input'
  $scope.step = 0

  $scope.go = -> 
    $scope.steps = extractSteps $scope.recipeText
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

TimerCtrl = ($scope, $timeout) ->
  unitToSeconds = (unit) ->
    switch 
      when unit.match 'seconds?' then 1
      when unit.match 'minutes?' then 60
      when unit.match 'hours?' then 60 * 60
  secondsToTime = (t) ->
    str = ""
    hours = Math.floor(t / (60 * 60))
    if hours > 0 then str = "#{hours}:"
    minutes = Math.floor((t / 60) % 60)
    minutesStr = if minutes < 10 then "0#{minutes}" else minutes
    seconds = t % 60
    secondsStr = if seconds < 10 then "0#{seconds}" else seconds
    "#{str}#{minutesStr}:#{secondsStr}"

  $scope.seconds = $scope.timer.time * unitToSeconds($scope.timer.unit)
  $scope.secondsPassed = 0
  $scope.running = false
  $scope.alarm = soundManager.createSound url: '/snd/alarm.mp3'

  $scope.onTimeout = ->
    $scope.secondsPassed = $scope.secondsPassed + 1
    if $scope.secondsLeft() > 0 then $scope.timeout = $timeout($scope.onTimeout,1000)
    else $scope.alarm.play()

  $scope.toggle = ->
    if $scope.running
      $scope.running = false
      $timeout.cancel $scope.timeout
      $scope.alarm.stop()
      if $scope.secondsLeft() <= 1 then $scope.secondsPassed = 0
    else
      $scope.running = true
      $scope.timeout = $timeout($scope.onTimeout,1000)

  $scope.reset = -> $scope.secondsPassed = 0

  $scope.secondsLeft = -> $scope.seconds - $scope.secondsPassed

  $scope.timeLeft = -> secondsToTime($scope.secondsLeft())

  $scope.buttonCaption = -> 
    if $scope.running 
      if $scope.secondsLeft() > 0 then 'Pause timer' else 'Stop timer'
    else 
      if $scope.secondsPassed > 0 then 'Resume timer' else 'Start timer'

root = exports ? this
root.RecipeCtrl = RecipeCtrl
root.TimerCtrl = TimerCtrl

$ ->
  soundManager.setup
    url: '/swf/'
    onready: ->