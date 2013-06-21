class Platform

  defaults:
    offset: 0
    range: 489
    direction: 'normal' # or alternate


  constructor: (platform) ->
    offset = platform.getAttribute 'data-offset'
    range = platform.getAttribute 'data-range'

    @element = platform
    @child = platform.firstElementChild
    @direction = @defaults.direction
    @offset = if offset? then parseInt(offset, 10) else @defaults.offset
    @range = if range? then parseInt(range, 10) else @defaults.range
    @width = platform.clientWidth

    @child.position.x += @offset


(exports ? this).Platform = Platform
