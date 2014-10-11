angular.module 'flynns', []

.factory 'kimono', ($http) ->
  apikey = 'apikey=3c4b8cd526ff926daf398b6213a1a256'
  url = 'https://www.kimonolabs.com/api/266j8z8q'
  callback = 'callback=JSON_CALLBACK'
  return {
    getData: ->
      $http.jsonp "#{url}?#{apikey}&#{callback}"
  }

.controller 'the-grid', (kimono, $scope) ->
  kimono.getData().success (data) ->
    $scope.programs = data.results.collection1

  $scope.base = +$('.grid--admin').css('z-index');


  $scope.option = (index) ->
    $num = Math.ceil (index + 1) / $scope.base
    $type = switch $num
      when 1 then 'asteroids'
      when 2 then 'battlezone'
      when 3 then 'centipede'
      when 4 then 'defender'
      when 5 then 'excitebike'
      when 6 then 'frogger'

    "arcade--#{$type}"
  # $scope.option = $('.grid--admin').css('content').replace(/\"/g,'')

  $scope.status = (text) ->
    # 'goldshow'

    switch text
      when 'Gold Show' then 'goldshow'
      when 'Party Chat' then 'partychat'
      when 'Live Now' then 'online'
      when 'Offline' then 'offline'

    # { \
    #         'goldshow': program.status.text == 'Gold Show', \
    #         'partychat': program.status.text == 'Party Chat', \
    #         'online': program.status.text == 'Live Now', \
    #         'offline': program.status.text == 'Offline', \
    #         'specialshow': $index === 1 \
    #       }

.controller 'eachThumb', ($scope, $rootScope, $timeout) ->
  $scope.isopen = false

  $rootScope.$on 'toggle', (evt, idx, rowCompare) ->
    if idx is $scope.$index
      $scope.isopen = !$scope.isopen
    else
      if rowCompare isnt 0
        $scope.isopen = false
      else
        $timeout ()->
          $scope.isopen = false
          return
        , 500


.controller 'inlineClicker', ($scope, inlineService) ->
  $scope.fire = (idx) ->
    console.log 'fire'
    inlineService.toggle(idx)
    return
  return

.factory 'inlineService', ($rootScope) ->

  rowOld = null
  rowNew = null

  index = null
  gridAdmin = null

  self =
    toggle: (idx)->
      perRow = gridAdmin.css('z-index')

      if index is idx
        index = null
      else
        index = idx
        rowNew = Math.floor(idx / perRow)

      rowCompare = 0
      if rowOld isnt null and rowNew isnt null
        if rowOld < rowNew
          rowCompare = 1
        if rowOld > rowNew
          rowCompare = -1

      rowOld = rowNew

      $rootScope.$emit 'toggle', idx, rowCompare

    getIndex: ()->
      return index

    setGridAdmin: (elem)->
      gridAdmin = elem

  return self

.directive 'gridAdmin', (inlineService) ->
  link: (scope, elem) ->
    inlineService.setGridAdmin elem
