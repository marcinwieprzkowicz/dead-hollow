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
      on_keydown: => @globals.movement.forward = 1
      on_keyup: => @globals.movement.forward = 0
      prevent_repeat: true
      prevent_default: true
    ,
      keys: 'left'
      on_keydown: => @globals.movement.backward = 1
      on_keyup: => @globals.movement.backward = 0
      prevent_repeat: true
      prevent_default: true
    ,
      keys: 'up'
      on_keydown: => @globals.movement.up = 1
      on_keyup: => @globals.movement.up = 0
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
    this


  actionButton: ->
    unless @globals.pause
      doorCollision = @map.collision.checkAll @map.objs.character.solid, @map.solid.doors, 0, 0

      if doorCollision.status
        wallClass = doorCollision.solid.element.className.match(/wall-\d+/g)[0]

        bgWall = document.querySelector "#background .#{wallClass}"
        fgWall = document.querySelector "#foreground .#{wallClass}"

        solidElement = fgWall.querySelector '.solid'
        solidIndex = parseInt solidElement.getAttribute('data-index'), 10
        solid = @globals.solids[solidIndex]

        solidCollision = @map.collision.checkBetween @map.objs.character.solid, solid, 0, @map.options.doorsRadius

        if !doorCollision.solid.element.classList.contains('pending') && !solidCollision.status
          bgWall.classList.toggle 'open'
          bgWall.classList.add 'pending'
          fgWall.classList.toggle 'open'
          fgWall.classList.add 'pending'
          solid.getHeightAgain()
          @game.audio.openingDoors.play() if @game.audio.openingDoors.getVolume() > 0
    this


  showTouchItems: ->
    item.style.display = 'block' for item in @touchItems
    this


  addControlEvents: ->
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
    this


  pause: ->
    if @globals.pause
      @game.start()
    else
      @game.pause()
      @fadeIn @game.element.game.overlay
      @fadeIn @game.menu.element.main.element
    this


(exports ? this).Control = Control
