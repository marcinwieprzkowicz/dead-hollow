###

Moving Platform CoffeeScript class.
Creates special type of platforms - moving platforms (Wow! I know, impressive, isn't it? ;)). 

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class MovingPlatform extends Base

  defaults:
    movingPlatform: '.platform.moving'
    solid: '.platform.moving .solid'
    offset: 0
    range: 489
    animation:
      shift: 5


  constructor: (options) ->
    super
    @elements =
      movingPlatform: document.querySelectorAll @options.movingPlatform
      solid: document.querySelectorAll @options.solid


  initPlatforms: ->
    @setOffset platform for platform in @elements.movingPlatform
    return


  setOffset: (platform) ->
    offset = platform.getAttribute 'data-offset'
    offset = if offset? then parseInt(offset, 10) else @options.offset
    range = platform.getAttribute 'data-range'
    range = if range? then parseInt(range, 10) else @options.range

    platform.movements =
      offset: offset
      range: range
      direction: 'normal'

    child = platform.firstElementChild
    child.position.x += offset if child?
    return


  draw: ->
    @move platform for platform in @elements.movingPlatform
    return


  move: (platform) ->
    child = platform.firstElementChild
    if platform.movements.direction == 'normal'
      platform.movements.offset += @options.animation.shift
      child.position.x += @options.animation.shift if child?
    else
      platform.movements.offset -= @options.animation.shift
      child.position.x -= @options.animation.shift if child?

    if platform.movements.offset == 0
      platform.movements.direction = 'normal'
    else if platform.movements.offset + platform.clientWidth >= platform.movements.range
      platform.movements.direction = 'alternate'

    platform.style[@cssTransform] = "translate3d(#{platform.movements.offset}px, 0, 0)"
    return


(exports ? this).MovingPlatform = MovingPlatform
