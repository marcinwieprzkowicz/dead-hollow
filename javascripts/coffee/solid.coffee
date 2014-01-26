###

Solid CoffeeScript class.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class Solid

  constructor: (element) ->
    @element = element
    @position = @getPosition element

    if element.classList.contains 'platform'
      @height = 1

      if element.classList.contains 'moving'
        @width = 94
        @position.x += 27
        @position.y += 10
      else if element.classList.contains 'cropped'
        @width = 88
      else if element.classList.contains 'floorDirection'
        @width = 161
        @position.x += 60
        @position.y += 24
      else if element.classList.contains 'floorAltDirection'
        @width = 60
        @position.y += 24
      else
        @width = 85
        @position.x += 27
    else if element.classList.contains 'box'
      @height = 95
      @width = 147
      @position.y += 8
      @position.x += 21
    else if element.classList.contains 'part'
      @height = 40
      @width = element.clientWidth
      @position.y += 120
    else
      @height = element.clientHeight
      @width = element.clientWidth


  getPosition: (element) ->
    x = 0
    y = 0
    while element.offsetParent
      x += element.offsetLeft
      y += element.offsetTop
      break if element.offsetParent.id == 'map'
      element = element.offsetParent
    x: x
    y: y


  getHeightAgain: ->
    @height = @element.clientHeight


(exports ? this).Solid = Solid
