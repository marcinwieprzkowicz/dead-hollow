###

Collision CoffeeScript class.
Really simple collision library, calculates the positions of solid element and doing some math stuff ;).
Provides two very useful methods: checkBetween & checkAll.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class Collision extends Base

  defaults:
    element:
      solids: '#map .solid'


  constructor: (options, @mapPosition) ->
    super
    solidElements = document.querySelectorAll @options.element.solids
    solidElementsLength = solidElements.length
    solidIterator = 0

    window.solids = new Array length

    while solidIterator < solidElementsLength
      solidElement = solidElements[solidIterator]
      solidElement.setAttribute 'data-index', solidIterator
      window.solids[solidIterator] = new Solid solidElement
      solidIterator++


  # checking the collisions between two elements
  checkBetween: (firstEl, secondEl, shiftX, shiftY) ->
    left = Math.max firstEl.position.x - @mapPosition.x - shiftX, secondEl.position.x
    right = Math.min firstEl.position.x + firstEl.width - @mapPosition.x - shiftX, secondEl.position.x + secondEl.width
    bottom = Math.max firstEl.position.y - @mapPosition.y - shiftY, secondEl.position.y
    top = Math.min firstEl.position.y + firstEl.height - @mapPosition.y - shiftY, secondEl.position.y + secondEl.height
    left < right && bottom < top


  # checking the collisions between one element and array
  checkAll: (element, elements = window.solids, shiftX, shiftY) ->
    handle =
      status: false
    length = elements.length - 1

    i = 0
    while true
      if @checkBetween element, elements[i], shiftX, shiftY
        handle =
          status: true
          solid: elements[i]
        break
      else if i is length
        break
      i++

    handle


(exports ? this).Collision = Collision
