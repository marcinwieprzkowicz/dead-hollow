###

Control CoffeeScript class.
Handles keyboard and touch events.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class Control extends Base

  defaults:
    touchItems: '.touch'
    control:
      backward: '.control .backward'
      forward: '.control .forward'
      buttonB: '.control .buttonB'
      buttonA: '.control .buttonA'
      pause: '.control.pause a'


  constructor: (options, @game, @map) ->
    super
    @touchItems = document.querySelectorAll @options.touchItems
    @control =
      backward: document.querySelector @options.control.backward
      forward: document.querySelector @options.control.forward
      buttonB: document.querySelector @options.control.buttonB
      buttonA: document.querySelector @options.control.buttonA
      pause: document.querySelector @options.control.pause


  addKeyboardEvents: ->
    movements = [
      keys: 'right'
      on_keydown: => @goRight()
      on_keyup: => @clearRight()
      prevent_repeat: true
      prevent_default: true
    ,
      keys: 'left'
      on_keydown: => @goLeft()
      on_keyup: => @clearLeft()
      prevent_repeat: true
      prevent_default: true
    ,
      keys: 'up'
      on_keydown: => @goUp()
      prevent_repeat: true
      prevent_default: true
    ,
      keys: 'space'
      on_keydown: => @actionButton()
      prevent_repeat: true
      prevent_default: true
    ,
      keys: 'escape'
      on_keydown: => @pause()
      prevent_repeat: true
      prevent_default: true
    ,
      keys: 'p'
      on_keydown: => @pause()
      prevent_repeat: true
      prevent_default: true
    ]

    keypress.register_many movements
    return


  # to do: DRY
  goRight: ->
    unless @game.paused
      @map.clearAnimation 'right'
      @map.clearAnimation 'left'

      interval = setInterval(=>
        collision = @map.collision.checkAll @map.objs.character.solid, null, -@map.options.animation.shift, 0

        @map.move -@map.options.animation.shift, 0 if !collision.status && !@map.animations.right.stopped
      , @map.options.animation.duration)

      @map.animations.right.interval = interval
      @map.objs.character.move()
    return


  clearRight: ->
    @map.clearAnimation 'right'
    @map.objs.character.stop 'run' unless @map.animations.left.interval?
    return


  goLeft: ->
    unless @game.paused
      @map.clearAnimation 'right'
      @map.clearAnimation 'left'

      interval = setInterval(=>
        collision = @map.collision.checkAll @map.objs.character.solid, null, @map.options.animation.shift, 0

        @map.move @map.options.animation.shift, 0 if !collision.status && !@map.animations.left.stopped
      , @map.options.animation.duration)

      @map.animations.left.interval = interval
      @map.objs.character.move true
    return


  clearLeft: ->
    @map.clearAnimation 'left'
    @map.objs.character.stop 'run' unless @map.animations.right.interval?
    return


  goUp: ->
    if !@map.animations.up.interval? && !@map.animations.up.stopped
      t = 0

      interval = setInterval(=>
        unless @game.paused
          y = Math.round(@map.objs.character.options.jump.force * @map.objs.character.options.jump.sinusAngle - @map.options.animation.gravity * t)
          @map.move 0, y
          t++
      , @map.options.animation.duration)

      @map.animations.up.interval = interval
    return


  actionButton: ->
    unless @game.paused
      doorCollision = @map.collision.checkAll @map.objs.character.solid, @map.solid.doors, 0, 0

      if doorCollision.status
        wallClass = doorCollision.solid.element.className.match(/wall-\d+/g)[0]

        bgWall = document.querySelector "#background .#{wallClass}"
        fgWall = document.querySelector "#foreground .#{wallClass}"

        solidElement = fgWall.querySelector '.solid'
        solidIndex = parseInt solidElement.getAttribute('data-index'), 10
        solid = window.solids[solidIndex]

        solidCollision = @map.collision.checkBetween @map.objs.character.solid, solid, 0, @map.options.doorsRadius

        if !doorCollision.solid.element.classList.contains('pending') && !solidCollision.status
          bgWall.classList.toggle 'open'
          bgWall.classList.add 'pending'
          fgWall.classList.toggle 'open'
          fgWall.classList.add 'pending'
          solid.getHeightAgain()
          @game.audio.openingDoors.play() if @game.audio.openingDoors.getVolume() > 0


  showTouchItems: ->
    i = 0
    length = @touchItems.length

    while i < length
      @touchItems[i].style.display = 'block'
      i++
    return


  addControlEvents: ->
    # disabling the context menu on long taps (Android)
    @preventLongPressMenu controller for controller in @control

    # left
    @addEvent(@control.backward, 'touchstart', =>
      document.body.onkeydown keyCode: 37
      @control.backward.classList.add 'touched'
    )

    @addEvent(@control.backward, 'touchend', =>
      document.body.onkeyup keyCode: 37
      @control.backward.classList.remove 'touched'
    )

    # right
    @addEvent(@control.forward, 'touchstart', =>
      document.body.onkeydown keyCode: 39
      @control.forward.classList.add 'touched'
    )

    @addEvent(@control.forward, 'touchend', =>
      document.body.onkeyup keyCode: 39
      @control.forward.classList.remove 'touched'
    )

    # button B
    @addEvent(@control.buttonB, 'touchstart', =>
      document.body.onkeydown keyCode: 38
      @control.buttonB.classList.add 'touched'
    )

    @addEvent(@control.buttonB, 'touchend', =>
      document.body.onkeyup keyCode: 38
      @control.buttonB.classList.remove 'touched'
    )

    # button A
    @addEvent(@control.buttonA, 'touchstart', =>
      document.body.onkeydown keyCode: 32
      @control.buttonA.classList.add 'touched'
    )

    @addEvent(@control.buttonA, 'touchend', =>
      document.body.onkeyup keyCode: 32
      @control.buttonA.classList.remove 'touched'
    )

    # pause
    @addEvent(@control.pause, 'touchstart', =>
      document.body.onkeydown keyCode: 27
      @control.pause.classList.add 'touched'
    )

    @addEvent(@control.pause, 'touchend', =>
      document.body.onkeyup keyCode: 27
      @control.pause.classList.remove 'touched'
    )
    return


  pause: ->
    if @game.paused
      @game.start()
    else
      @game.pause()
      @fadeIn @game.element.game.overlay
      @fadeIn @game.menu.element.main.element
    return


(exports ? this).Control = Control
