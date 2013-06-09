###

Menu CoffeeScript class.
Provides all services for menu.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class Menu extends Base

  defaults:
    menu:
      element: '#menu'
      items: '#menu a'
    section:
      credits: '#credits'
      settings: '#settings'
      gameOver: '#game-over'
      aboutMe: '#about-me'
    theEnd:
      header: '#credits .heading h2'
      congratulations: '.congratulations'
    backToMenu: '.backToMenu'
    retry: '.retryTrigger'


  dragdealerDefaults =
    slide: false
    steps: 100
    left: -10
    right: -10
    animationCallback: (value) ->
      filled = @wrapper.querySelector '.filled'
      filled.style.width = "#{value * 100}%"


  constructor: (options) ->
    super
    @element =
      main:
        element: document.querySelector @options.menu.element
        items: document.querySelectorAll @options.menu.items
      section:
        credits: document.querySelector @options.section.credits
        settings: document.querySelector @options.section.settings
        gameOver: document.querySelector @options.section.gameOver
        aboutMe: document.querySelector @options.section.aboutMe
      theEnd:
        header: document.querySelector @options.theEnd.header
        congratulations: document.querySelector @options.theEnd.congratulations
      backToMenu: document.querySelectorAll @options.backToMenu
      retry: document.querySelector @options.retry

    window.test = @game = new Game({}, this)
    @setupEvents()


  setupEvents: ->
    @menuItem item for item in @element.main.items
    @backToMenu link for link in @element.backToMenu

    @addEvent @element.retry, 'click', (event) =>
      @preventDefault event
      @fadeOut @element.section.gameOver
      @game.start()
    return


  menuItem: (item) ->
    @addEvent item, 'click', (event) =>
      bindTo = item.getAttribute 'data-bind'
      this[bindTo].call this, event if this[bindTo]
    return


  backToMenu: (link) ->
    @addEvent link, 'click', (event) =>
      @preventDefault event
      activeEl = link.getAttribute 'data-back'
      @fadeOut @element.section[activeEl]
      @fadeIn @element.main.element
    return


  startGame: (event) ->
    @preventDefault event
    @game.start()
    @fadeOut @element.main.element
    return


  settings: (event) ->
    @preventDefault event
    @fadeOut @element.main.element
    @fadeIn @element.section.settings
    @flexcrollContent @element.section.settings

    if !@musicVolume && !Modernizr.ismobile
      musicVolumeOptions = @merge {}, dragdealerDefaults,
        x: @game.audio.background.getVolume() / 100
        callback: (value) =>
          volume = Math.round value * 100
          @game.audio.background.setVolume volume

      @musicVolume = new Dragdealer('music-volume-slider', musicVolumeOptions)

    unless @soundsVolume
      soundsVolumeOptions = @merge {}, dragdealerDefaults,
        x: @game.audio.running.getVolume() / 100
        callback: (value) =>
          volume = Math.round value * 100
          @game.sounds.setVolume volume

      @soundsVolume = new Dragdealer('sounds-volume-slider', soundsVolumeOptions)
    return


  credits: (event) ->
    @preventDefault event

    @setText @element.theEnd.header, 'Credits'
    @element.theEnd.congratulations.style.display = 'none'

    @fadeOut @element.main.element
    @fadeIn @element.section.credits
    @flexcrollContent @element.section.credits
    return


  quit: (event) ->
    @preventDefault event unless confirm 'Are you sure?'
    return


(exports ? this).Menu = Menu
