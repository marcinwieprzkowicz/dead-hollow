###

Game CoffeeScript class.

"One Class to rule them all,
One Class to find them,
One Class to bring them all
and in the darkness bind them."

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class Game extends Base

  defaults:
    game:
      overlay: '#game .overlay'
      start: '#start-game'


  constructor: (options, @menu) ->
    super
    @paused = null
    @elements =
      game:
        overlay: document.querySelector @options.game.overlay
        start: document.querySelector @options.game.start

    @initAudio()
    @map = new Map({}, this)
    @character = new Character(
      id: 'character'
      klass: 'visualization'
    ,
      @audio
    )
    @control = new Control {}, this, @map


  start: ->
    @fadeOut @elements.game.overlay
    @fadeOut @menu.element.main.element

    if @paused is null
      @control.addKeyboardEvents()
      if Modernizr.touch
        @control.showTouchItems()
        @control.addControlEvents()

      @map.add @character #add character mainObj to map

    setTimeout(=>
      @setText @elements.game.start, 'Resume'
    , 600)

    @paused = false
    @character.clear()
    @map.animationsStopped false

    @animation = setInterval =>
      @map.draw()
      return
    , 50
    return


  pause: ->
    @paused = true
    @character.domEl.classList.add 'paused'
    @map.animationsStopped true
    clearInterval @animation
    return


  reset: ->
    @map.setDefaultPosition()
    @map.closeDoors()
    @map.clearAnimation 'up'
    @map.clearAnimation 'right'
    @map.clearAnimation 'left'

    setTimeout(=>
      @setText @elements.game.start, 'Start game'
      @map.draw()
    , 1000)
    return


  theEnd: ->
    @pause()
    @reset()

    @setText @menu.element.theEnd.header, 'The end'
    @menu.element.theEnd.congratulations.style.display = 'block'

    @fadeIn @elements.game.overlay
    @fadeIn @menu.element.section.credits
    @flexcrollContent @menu.element.section.credits
    return


  gameOver: (speed) ->
    @character.domEl.classList.add 'death'
    @character.domEl.style[@cssTransform] = "translate3d(0, #{Math.abs(speed) * 20}px, 0)"

    setTimeout(=>
      @pause()
      @reset()
      @fadeIn @menu.element.section.gameOver
    , 1000)
    return


  aboutMe: ->
    @pause()
    @reset()
    @fadeIn @elements.game.overlay
    @fadeIn @menu.element.section.aboutMe
    @flexcrollContent @menu.element.section.aboutMe
    return


  initAudio: ->
    buzz.defaults.preload = 'none' if Modernizr.ismobile
    buzz.defaults.formats = ['ogg', 'm4a']
    buzz.defaults.volume = if Modernizr.ismobile then 0 else 15

    @audio =
      background: new buzz.sound('audio/background',
        autoplay: !Modernizr.ismobile
        loop: true
        volume: 10
      )
      running: new buzz.sound('audio/running',
        loop: true
      )
      landing: new buzz.sound('audio/landing',
        loop: false
      )
      openingDoors: new buzz.sound('audio/opening-doors',
        loop: false
      )

    @sounds = new buzz.group([
      @audio.running,
      @audio.landing,
      @audio.openingDoors
    ])
    return


(exports ? this).Game = Game
