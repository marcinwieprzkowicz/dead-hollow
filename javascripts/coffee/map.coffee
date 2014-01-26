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
    this


  addEvents: ->
    i = 0
    length = @element.doors.length
    transitionEnd = @globals.event.transitionEnd

    while i < length
      @addEvent @element.doors[i], transitionEnd, (event) ->
        event.target.parentNode.classList.remove 'pending'
        return
      i++
    return


  add: (element) ->
    @element.map.appendChild element.domElement
    @objs[element.options.id] = element

    element.solid = new Solid element.domElement
    return


  draw: ->
    requestAnimationFrame =>
      @element.foreground.style[@globals.css.transform] = "translate3d(#{@position.x}px, #{@position.y}px, 0)"
      @element.background.style[@globals.css.transform] = "translate3d(#{@position.x}px, #{@position.y}px, 0)"
      @movingPlatform.draw()
      return


  move: (x, y) ->
    @position.x += x

    if @position.y + y >= @options.position.y
      @position.y += y
    else
      @position.y = @options.position.y

      lowerVerticalCollision = @collision.checkAll @objs.character.solid, null, 0, -@options.animation.shift
      @game.gameOver y unless lowerVerticalCollision.status
    return


  handleCollisions: ->
    horizontal = (@globals.movement.backward - @globals.movement.forward) * @options.animation.shift
    vertical = 0

    if horizontal != 0
      horizontalCollision = @collision.checkAll @objs.character.solid, null, horizontal, 0
      @objs.character.move horizontal > 0
      horizontal = 0 if horizontalCollision.status
    else
      @objs.character.stop 'run'

    lowerVerticalCollision = @collision.checkAll @objs.character.solid, null, 0, -@options.animation.shift

    if lowerVerticalCollision.status # landing
      # character.y + character.height - lowerCollision element.y - @position.y
      lessThanShift = @objs.character.solid.position.y + @objs.character.solid.height - lowerVerticalCollision.solid.position.y - @position.y
      vertical += lessThanShift

      @objs.character.stop 'jump' if @objs.character.inAir
    else
      upperVerticalCollision = @collision.checkAll @objs.character.solid, null, 0, @options.animation.shift
      @objs.character.appliedForce = 0 if upperVerticalCollision.status
      @objs.character.jump()
      # gravity
      y = -@options.animation.gravity * @objs.character.ticks
      @objs.character.ticks++
      vertical += y

    vertical += @objs.character.appliedForce
    @objs.character.appliedForce = @objs.character.options.jump.force if @globals.movement.up && !@objs.character.inAir
    @move horizontal, vertical

    movingCol = @collision.checkAll @objs.character.solid, @movingPlatform.solid, 0, -@options.animation.shift
    if movingCol.status
      index = @getIndex movingCol.solid.element

      if @movingPlatform.platform[index].direction == 'normal'
        @move -@movingPlatform.options.animation.shift, 0
      else
        @move @movingPlatform.options.animation.shift, 0

    @game.theEnd() if @collision.checkBetween @objs.character.solid, @solid.theEndTrigger, 0, 0
    @game.aboutMe() if @collision.checkBetween @objs.character.solid, @solid.infoTrigger, 0, 0
    return


  closeDoors: ->
    door.classList.remove 'open' for door in @element.doors
    this


(exports ? this).Map = Map
