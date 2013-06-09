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
      height: 120
      angle: Math.PI / 4 #45 deg


  constructor: (options, @audio) ->
    @setOptions options

    @inAir = 0 # 0 - false | > 0 - true
    @createEl()


  setOptions: (options) ->
    super
    @cssTransform = Modernizr.prefixed 'transform'
    @options.jump.sinusAngle = Math.round Math.sin(@options.jump.angle)
    @options.jump.force = Math.round(Math.sqrt(2 * @options.jump.height * 2) / @options.jump.sinusAngle)


  createEl: ->
    subEl = document.createElement 'div'
    subEl.classList.add @options.klass

    @domEl = document.createElement 'div'
    @domEl.id = @options.id
    @domEl.appendChild subEl
    this


  clear: ->
    @domEl.style[@cssTransform] = 'translate3d(0, 0, 0)'
    @domEl.classList.remove 'death'
    @domEl.classList.remove 'paused'
    this


  move: (inverted = false) ->
    if inverted then @domEl.classList.add 'inverted' else @domEl.classList.remove 'inverted'
    if !@inAir
      @domEl.classList.add 'run'
      @audio.running.play() if @audio.running.getVolume() > 0
    this


  jump: ->
    @inAir = 1
    @domEl.classList.add 'jump'
    @audio.running.stop() if @audio.running.getVolume() > 0
    this


  stop: (animation, callback) ->
    switch animation
      when 'run'
        @domEl.classList.remove 'run'
        @audio.running.stop() if @audio.running.getVolume() > 0
        callback.call this if callback?
      when 'jump'
        @inAir = 0
        @domEl.classList.add 'inAir'
        @domEl.classList.remove 'jump'
        @domEl.classList.add 'landing'
        @audio.landing.play() if @audio.landing.getVolume() > 0
        setTimeout(=>
          @domEl.classList.remove 'landing'
          @domEl.classList.remove 'inAir'
          callback.call this if callback?
        , 200)
    this


(exports ? this).Character = Character
