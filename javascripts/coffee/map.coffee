###

Map CoffeeScript class.
Moves/draws a map, handles collisions and also contains animations object.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class Map extends Base

  defaults:
    position:
      x: -2500
      y: 50
    element:
      map: '#map'
      foreground: '#foreground'
      background: '#background'
      doors: '.door'
      theEndTrigger: '#the-end-trigger'
      infoTrigger: '#info div'
    animation:
      shift: 10
      gravity: 2
      duration: 50
    doorsRadius: 70


  constructor: (options, @game) ->
    super
    @setDefaultPosition()

    @animations =
      right:
        interval: undefined
        stopped: true
      left:
        interval: undefined
        stopped: true
      up:
        interval: undefined
        stopped: true

    @objs = {}
    @element =
      map: document.querySelector @options.element.map
      foreground: document.querySelector @options.element.foreground
      background: document.querySelector @options.element.background
      doors: document.querySelectorAll @options.element.doors
      theEndTrigger: document.querySelector @options.element.theEndTrigger
      infoTrigger: document.querySelector @options.element.infoTrigger

    @element.map.style.display = 'block'
    @collision = new Collision {}, @position

    doors = []
    doors.push new Solid(door) for door in @element.doors

    @solid =
      doors: doors
      theEndTrigger: new Solid @element.theEndTrigger
      infoTrigger: new Solid @element.infoTrigger

    @movingPlatform = new MovingPlatform
    @addEvents()


  setDefaultPosition: =>
    @position = {} unless @position?
    @position.x = @options.position.x
    @position.y = @options.position.y
    return


  addEvents: ->
    i = 0
    length = @element.doors.length
    transitionEnd = @getTransitionEndName()

    while i < length
      @addEvent @element.doors[i], transitionEnd, (event) ->
        event.target.parentNode.classList.remove 'pending'
        return
      i++
    return


  animationsStopped: (stopped) ->
    @animations.right.stopped = stopped
    @animations.left.stopped = stopped
    @animations.up.stopped = stopped
    return


  add: (element) ->
    @element.map.appendChild element.domEl
    @objs[element.options.id] = element

    element.solid = new Solid element.domEl
    return


  draw: ->
    requestAnimationFrame =>
      @element.foreground.style[@cssTransform] = "translate3d(#{@position.x}px, #{@position.y}px, 0)"
      @element.background.style[@cssTransform] = "translate3d(#{@position.x}px, #{@position.y}px, 0)"
      @movingPlatform.draw()

      @handleCollisions()
    return


  move: (x, y) ->
    @position.x += x

    if @position.y + y >= @options.position.y
      @position.y += y
    else
      @position.y = @options.position.y

      lowerCollision = @collision.checkAll @objs.character.solid, null, 0, -@options.animation.shift
      @game.gameOver y unless lowerCollision.status
    return


  clearAnimation: (animation) ->
    if animation of @animations
      interval = @animations[animation].interval
      if interval?
        clearInterval interval
        @animations[animation] =
          interval: undefined
          stopped: @game.paused
    return


  handleCollisions: ->
    lowerCollision = @collision.checkAll @objs.character.solid, null, 0, -@options.animation.shift

    if lowerCollision.status
      #character.y + character.height - lowerCollision element.y - @position.y
      lessThanShift = @objs.character.solid.position.y + @objs.character.solid.height - lowerCollision.solid.position.y - @position.y
      @move 0, lessThanShift

      #handle landing
      if @objs.character.inAir
        @clearAnimation 'up'

        callback = =>
          @animations.up.stopped = false
          @objs.character.move() if @animations.right.interval?
          @objs.character.move(true) if @animations.left.interval?

        @objs.character.stop 'jump', callback
    else
      upperCollision = @collision.checkAll @objs.character.solid, null, 0, @options.animation.shift

      if upperCollision.status
        @clearAnimation 'up'
        @animations.up.stopped = true # prevent jumping in air
        @move 0, -@options.animation.shift
      else if !@objs.character.inAir
        #handle jumping
        @animations.up.stopped = true
        @objs.character.stop 'run'
        @objs.character.jump()
      else if !@animations.up.interval?
        y = @options.animation.gravity * @objs.character.inAir
        @move 0, -y
        @objs.character.inAir++

    movingCol = @collision.checkAll @objs.character.solid, @movingPlatform.solid, 0, -@options.animation.shift
    if movingCol.status
      index = @getIndex movingCol.solid.element.parentNode
    
      if @movingPlatform.platform[index].direction == 'normal'
        @move -@movingPlatform.options.animation.shift, 0
      else
        @move @movingPlatform.options.animation.shift, 0

    @game.theEnd() if @collision.checkBetween @objs.character.solid, @solid.theEndTrigger, 0, 0
    @game.aboutMe() if @collision.checkBetween @objs.character.solid, @solid.infoTrigger, 0, 0
    return


  closeDoors: ->
    door.classList.remove 'open' for door in @element.doors
    return


(exports ? this).Map = Map
