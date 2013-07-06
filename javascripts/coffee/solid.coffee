###

Solid CoffeeScript class.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class Solid

  constructor: (element) ->
    @element = element

    @position = @getPosition element
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
