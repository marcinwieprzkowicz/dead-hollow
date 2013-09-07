###

Character CoffeeScript class.
Creates a main character and controls all of his behavior.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class Character extends Base

  defaults:
    # id:
    # klass:
    animation:
      gravity: 2
    jump:
      force: 0
      height: 120


  constructor: (options, @audio) ->
    super
    @options.jump.force = Math.round Math.sqrt(2 * @options.jump.height * @options.animation.gravity)
    @setDefaults()
    @createDomElement()


  setDefaults: ->
    @inAir = false
    @appliedForce = 0
    @ticks = 1
    this


  createDomElement: ->
    subElement = document.createElement 'div'
    subElement.classList.add @options.klass

    @domElement = document.createElement 'div'
    @domElement.id = @options.id
    @domElement.appendChild subElement
    this


  reset: ->
    @domElement.style[@globals.css.transform] = 'translate3d(0, 0, 0)' # after death
    @domElement.className = ''
    @setDefaults()
    this


  move: (inverted = false) ->
    if inverted then @domElement.classList.add 'inverted' else @domElement.classList.remove 'inverted'
    if !@inAir
      @domElement.classList.add 'run'
      @audio.running.play() if @audio.running.getVolume() > 0
    return


  jump: ->
    @inAir = true
    @domElement.classList.add 'jump'
    @audio.running.stop() if @audio.running.getVolume() > 0
    return


  stop: (animation) ->
    switch animation
      when 'run'
        @domElement.classList.remove 'run'
        @audio.running.stop() if @audio.running.getVolume() > 0
      when 'jump'
        @setDefaults()
        @domElement.classList.add 'inAir'
        @domElement.classList.remove 'jump'
        @domElement.classList.add 'landing'
        @audio.landing.play() if @audio.landing.getVolume() > 0
        setTimeout(=>
          @domElement.classList.remove 'landing', 'inAir'
        , 200)
    return


(exports ? this).Character = Character
