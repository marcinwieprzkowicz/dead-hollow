###

Control CoffeeScript class.
Handles keyboard and touch events.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class Control extends Base

  defaults:
    touchItems: '.touch'
    controls:
      backward: '.control .backward'
      forward: '.control .forward'
      buttonB: '.control .buttonB'
      buttonA: '.control .buttonA'
      pause: '.control.pause a'


  constructor: (options, @game, @map) ->
    super
    @touchItems = document.querySelectorAll @options.touchItems
    @controls =
      backward: document.querySelector @options.controls.backward
      forward: document.querySelector @options.controls.forward
      buttonB: document.querySelector @options.controls.buttonB
      buttonA: document.querySelector @options.controls.buttonA
      pause: document.querySelector @options.controls.pause


  addKeyboardEvents: ->
    movements = [
      keys: 'right'
      on_keydown: =>
        @controls.forward.classList.add 'touched'
        @controls.backward.classList.remove 'touched'
        unless @game.paused
          @map.clearAnimation 'right'
          @map.clearAnimation 'left'

          interval = setInterval(=>
            collision = @map.collision.checkAll @map.objs.character.domEl, null, -@map.options.animation.shift, 0

            @map.move -@map.options.animation.shift, 0 if !collision.status && !@map.animations.right.stopped
          , @map.options.animation.duration)

          @map.animations.right.interval = interval
          @map.objs.character.move()
      on_keyup: =>
        @controls.forward.classList.remove 'touched'
        @map.clearAnimation 'right'
        @map.objs.character.stop 'run' unless @map.animations.left.interval?
      prevent_repeat: true
      prevent_default: true
    ,
      keys: 'left'
      on_keydown: =>
        @controls.backward.classList.add 'touched'
        @controls.forward.classList.remove 'touched'
        unless @game.paused
          @map.clearAnimation 'right'
          @map.clearAnimation 'left'

          interval = setInterval(=>
            collision = @map.collision.checkAll @map.objs.character.domEl, null, @map.options.animation.shift, 0

            @map.move @map.options.animation.shift, 0 if !collision.status && !@map.animations.left.stopped
          , @map.options.animation.duration)

          @map.animations.left.interval = interval
          @map.objs.character.move true
      on_keyup: =>
        @controls.backward.classList.remove 'touched'
        @map.clearAnimation 'left'
        @map.objs.character.stop 'run' unless @map.animations.right.interval?
      prevent_repeat: true
      prevent_default: true
    ,
      keys: 'up'
      on_keydown: =>
        @controls.buttonB.classList.add 'touched'
        if !@map.animations.up.interval? && !@map.animations.up.stopped
          t = 0

          interval = setInterval(=>
            unless @game.paused
              y = Math.round(@map.objs.character.options.jump.force * @map.objs.character.options.jump.sinusAngle - @map.options.animation.gravity * t)
              @map.move 0, y
              t++
          , @map.options.animation.duration)

          @map.animations.up.interval = interval
      on_keyup: =>
        @controls.buttonB.classList.remove 'touched'
      prevent_repeat: true
      prevent_default: true
    ,
      keys: 'space'
      on_keydown: =>
        @controls.buttonA.classList.add 'touched'
        unless @game.paused
          doorCollision = @map.collision.checkAll @map.objs.character.domEl, @map.elements.door, 0, 0

          if doorCollision.status
            classList = doorCollision.element.getAttribute 'class'
            wallClass = classList.match(/wall-\d+/g)[0]

            bgWall = document.querySelector "#background .#{wallClass}"
            fgWall = document.querySelector "#foreground .#{wallClass}"

            solidCollision = @map.collision.checkBetween @map.objs.character.domEl, fgWall.querySelector('.solid'), 0, @map.options.doorsRadius

            if !doorCollision.element.classList.contains('pending') && !solidCollision
              bgWall.classList.toggle 'open'
              bgWall.classList.add 'pending'
              fgWall.classList.toggle 'open'
              fgWall.classList.add 'pending'
              @game.audio.openingDoors.play() if @game.audio.openingDoors.getVolume() > 0
      on_keyup: =>
        @controls.buttonA.classList.remove 'touched'
      prevent_repeat: true
      prevent_default: true
    ,
      keys: 'escape'
      on_keydown: =>
        @controls.pause.classList.add 'touched'
        if @game.paused then @game.start() else @pause()
      on_keyup: =>
        @controls.pause.classList.remove 'touched'
      prevent_repeat: true
      prevent_default: true
    ,
      keys: 'p'
      on_keydown: =>
        @controls.pause.classList.add 'touched'
        if @game.paused then @game.start() else @pause()
      on_keyup: =>
        @controls.pause.classList.remove 'touched'
      prevent_repeat: true
      prevent_default: true
    ]
    keypress.register_many movements
    return


  showTouchItems: ->
    i = 0
    while i < @touchItems.length
      @touchItems[i].style.display = 'block'
      i++
    return


  addControlEvents: ->
    # left
    @addEvent(@controls.backward, 'touchstart', =>
      document.body.onkeydown keyCode: 37
      @controls.backward.classList.add 'touched'
    )

    @addEvent(@controls.backward, 'touchend', =>
      document.body.onkeyup keyCode: 37
      @controls.backward.classList.remove 'touched'
    )

    # right
    @addEvent(@controls.forward, 'touchstart', =>
      document.body.onkeydown keyCode: 39
      @controls.forward.classList.add 'touched'
    )

    @addEvent(@controls.forward, 'touchend', =>
      document.body.onkeyup keyCode: 39
      @controls.forward.classList.remove 'touched'
    )

    # button B
    @addEvent(@controls.buttonB, 'touchstart', =>
      document.body.onkeydown keyCode: 38
      @controls.buttonB.classList.add 'touched'
    )

    @addEvent(@controls.buttonB, 'touchend', =>
      document.body.onkeyup keyCode: 38
      @controls.buttonB.classList.remove 'touched'
    )

    # button A
    @addEvent(@controls.buttonA, 'touchstart', =>
      document.body.onkeydown keyCode: 32
      @controls.buttonA.classList.add 'touched'
    )

    @addEvent(@controls.buttonA, 'touchend', =>
      document.body.onkeyup keyCode: 32
      @controls.buttonA.classList.remove 'touched'
    )

    # pause
    @addEvent(@controls.pause, 'touchstart', =>
      document.body.onkeydown keyCode: 27
      @controls.pause.classList.add 'touched'
    )

    @addEvent(@controls.pause, 'touchend', =>
      document.body.onkeyup keyCode: 27
      @controls.pause.classList.remove 'touched'
    )
    return


  pause: ->
    @game.pause()
    @fadeIn @game.elements.game.overlay
    @fadeIn @game.menu.element.main.element
    return


(exports ? this).Control = Control
