###

Platform CoffeeScript class.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class Platform

  defaults:
    offset: 0
    range: 489
    direction: 'normal' # or alternate


  constructor: (element) ->
    offset = element.getAttribute 'data-offset'
    range = element.getAttribute 'data-range'

    @element = element
    @direction = @defaults.direction
    @offset = if offset? then parseInt(offset, 10) else @defaults.offset
    @range = if range? then parseInt(range, 10) else @defaults.range
    @width = element.clientWidth

    solidIndex = parseInt element.firstElementChild.getAttribute('data-index'), 10
    @solid = window.solids[solidIndex]
    @solid.position.x += @offset


(exports ? this).Platform = Platform
