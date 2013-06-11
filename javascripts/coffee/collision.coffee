###

Collision CoffeeScript class.
Really simple collision library, calculates the positions of solid element and doing some math stuff ;).
Provides two very useful methods: checkBetween & checkAll.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


getPosition = (obj) ->
  x = 0
  y = 0
  while obj.offsetParent
    x += obj.offsetLeft
    y += obj.offsetTop
    break if obj.offsetParent.id == 'map'
    obj = obj.offsetParent
  x: x
  y: y


class Collision extends Base

  defaults:
    elements:
      solid: '#map .solid'


  constructor: (options, @mapPosition) ->
    super
    @elements =
      solid: document.querySelectorAll @options.elements.solid

    @calcPositions @elements.solid


  calcPositions: (el) ->
    length = el.length

    if length
      i = 0
      while i < length
        current = el[i]
        current.position = getPosition current
        i++
    else
      el.position = getPosition el
    return


  # checking the collisions between two elements
  checkBetween: (firstEl, secondEl, shiftX, shiftY) ->
    left = Math.max firstEl.position.x - @mapPosition.x - shiftX, secondEl.position.x
    right = Math.min firstEl.position.x + firstEl.clientWidth - @mapPosition.x - shiftX, secondEl.position.x + secondEl.clientWidth
    bottom = Math.max firstEl.position.y - @mapPosition.y - shiftY, secondEl.position.y
    top = Math.min firstEl.position.y + firstEl.clientHeight - @mapPosition.y - shiftY, secondEl.position.y + secondEl.clientHeight
    left < right && bottom < top


  # checking the collisions between one element and array
  checkAll: (element, elements = @elements.solid, shiftX, shiftY) ->
    handle =
      status: false
    length = elements.length - 1

    i = 0
    while true
      if @checkBetween element, elements[i], shiftX, shiftY
        handle =
          status: true
          element: elements[i]
        break
      else if i is length
        break
      i++

    handle


(exports ? this).Collision = Collision
