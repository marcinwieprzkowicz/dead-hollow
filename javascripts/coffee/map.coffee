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
    elements:
      map: '#map'
      foreground: '#foreground'
      background: '#background'
      door: '.door'
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
    @elements =
      map: document.querySelector @options.elements.map
      foreground: document.querySelector @options.elements.foreground
      background: document.querySelector @options.elements.background
      door: document.querySelectorAll @options.elements.door
      theEndTrigger: document.querySelector @options.elements.theEndTrigger
      infoTrigger: document.querySelector @options.elements.infoTrigger

    @elements.map.style.display = 'block'
    @collision = new Collision({}, @position)
    @collision.calcPositions @elements.door
    @collision.calcPositions @elements.theEndTrigger
    @collision.calcPositions @elements.infoTrigger
    @movingPlatform = new MovingPlatform()

    @addEvents()


  setDefaultPosition: =>
    @position = {} unless @position?
    @position.x = @options.position.x
    @position.y = @options.position.y
    return


  addEvents: ->
    i = 0
    transitionEnd = @getTransitionEndName()

    while i < @elements.door.length
      @addEvent(@elements.door[i], transitionEnd, (event) ->
        event.srcElement.parentNode.classList.remove 'pending'
      )
      i++
    return


  animationsStopped: (stopped) ->
    @animations.right.stopped = stopped
    @animations.left.stopped = stopped
    @animations.up.stopped = stopped
    return


  add: (element) ->
    @elements.map.appendChild element.domEl
    @objs[element.options.id] = element

    @collision.calcPositions element.domEl
    return


  draw: ->
    @elements.foreground.style[@cssTransform] = "translate3d(#{@position.x}px, #{@position.y}px, 0)"
    @elements.background.style[@cssTransform] = "translate3d(#{@position.x}px, #{@position.y}px, 0)"
    @movingPlatform.draw()
    return


  move: (x, y) ->
    @position.x += x

    if @position.y + y >= @options.position.y
      @position.y += y
    else
      @position.y = @options.position.y

      lowerCollision = @collision.checkAll @objs.character.domEl, null, 0, -@options.animation.shift
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
    lowerCollision = @collision.checkAll @objs.character.domEl, null, 0, -@options.animation.shift

    if lowerCollision.status
      #character.y + character.height - lowerCollision element.y - @position.y
      lessThanShift = @objs.character.domEl.position.y + @objs.character.domEl.clientHeight - lowerCollision.element.position.y - @position.y
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
      upperCollision = @collision.checkAll @objs.character.domEl, null, 0, @options.animation.shift

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

    movingCol = @collision.checkAll @objs.character.domEl, @movingPlatform.elements.solid, 0, -@options.animation.shift
    if movingCol.status
      if movingCol.element.parentNode.movements.direction == 'normal'
        @move -@movingPlatform.options.animation.shift, 0
      else
        @move @movingPlatform.options.animation.shift, 0

    @game.theEnd() if @collision.checkBetween @objs.character.domEl, @elements.theEndTrigger, 0, 0
    @game.aboutMe() if @collision.checkBetween @objs.character.domEl, @elements.infoTrigger, 0, 0
    return


  closeDoors: ->
    door.classList.remove 'open' for door in @elements.door
    return


(exports ? this).Map = Map
