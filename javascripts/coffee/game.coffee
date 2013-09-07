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
    @element =
      game:
        overlay: document.querySelector @options.game.overlay
        start: document.querySelector @options.game.start

    @initAudio()
    @map = new Map {}, this
    @character = new Character(
      id: 'character'
      klass: 'visualization'
    ,
      @audio
    )
    @map.add @character #add character mainObj to map

    @control = new Control {}, this, @map
    @control.addKeyboardEvents()
    @control.showTouchItems().addControlEvents() if Modernizr.touch


  start: ->
    @fadeOut [@element.game.overlay, @menu.element.main.element], =>
      @setText @element.game.start, 'Resume'

    @character.domElement.classList.remove 'paused'
    @globals.pause = false

    # main loop
    @animation = setInterval =>
      @map.handleCollisions()
      @map.draw()
      return
    , 50

    return


  pause: ->
    clearInterval @animation
    @globals.pause = true
    @character.domElement.classList.add 'paused'
    return


  reset: ->
    @map.setDefaultPosition().closeDoors()
    @character.reset()

    setTimeout(=>
      @setText @element.game.start, 'Start game'
    , 1000)
    return


  theEnd: ->
    @pause()

    @setText @menu.element.theEnd.header, 'The end'
    @menu.element.theEnd.congratulations.style.display = 'block'

    @fadeIn [@element.game.overlay, @menu.element.section.credits], => @reset()
    @flexcrollContent @menu.element.section.credits
    return


  gameOver: (speed) ->
    @character.domElement.classList.add 'death'
    @character.domElement.style[@globals.css.transform] = "translate3d(0, #{Math.abs(speed) * 20}px, 0)"

    setTimeout(=>
      @pause()
      @fadeIn [@element.game.overlay, @menu.element.section.gameOver], => @reset()
    , 1000)
    return


  aboutMe: ->
    @pause()
    @fadeIn [@element.game.overlay, @menu.element.section.aboutMe], => @reset()
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
