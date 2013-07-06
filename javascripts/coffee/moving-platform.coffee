###

Moving Platform CoffeeScript class.
Creates special type of platforms - moving platforms (Wow! I know, impressive, isn't it? ;)). 

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class MovingPlatform extends Base

  defaults:
    movingPlatform: '.platform.moving'
    solid: '.platform.moving .solid'
    animation:
      shift: 5


  constructor: (options) ->
    super
    @element =
      movingPlatform: document.querySelectorAll @options.movingPlatform
      solid: document.querySelectorAll @options.solid

    movingPlatformLength = @element.movingPlatform.length
    movingPlatformIterator = 0

    @platform = new Array movingPlatformLength
    @solid = new Array movingPlatformLength

    while movingPlatformIterator < movingPlatformLength
      platform = @element.movingPlatform[movingPlatformIterator]
      index = @getIndex platform

      @platform[index] = new Platform platform
      @solid[movingPlatformIterator] = @platform[index].solid
      movingPlatformIterator++


  draw: ->
    @move platform for platform in @platform when platform?
    return


  move: (platform) ->
    if platform.direction == 'normal'
      platform.offset += @options.animation.shift
      platform.solid.position.x += @options.animation.shift
    else
      platform.offset -= @options.animation.shift
      platform.solid.position.x -= @options.animation.shift

    if platform.offset == 0
      platform.direction = 'normal'
    else if platform.offset + platform.width >= platform.range
      platform.direction = 'alternate'

    platform.element.style[@cssTransform] = "translate3d(#{platform.offset}px, 0, 0)"
    return


(exports ? this).MovingPlatform = MovingPlatform
