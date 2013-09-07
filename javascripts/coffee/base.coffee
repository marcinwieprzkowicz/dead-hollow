###

Base CoffeeScript class based on: https://gist.github.com/rpflorence/3681784.
The most important functionality is 'setOptions' - brings back good memories of MooTools :).
It also contains many useful functions.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


transitionEnd = ->
  transitionEndEventNames =
    'WebkitTransition' : 'webkitTransitionEnd'
    'MozTransition'    : 'transitionend'
    'OTransition'      : 'oTransitionEnd'
    'msTransition'     : 'MSTransitionEnd'
    'transition'       : 'transitionend'
  transitionEndEventNames[ Modernizr.prefixed 'transition' ]


class Base

  defaults: {}


  constructor: (options) ->
    @setOptions options
    @globals = @initGlobals()


  setOptions: (options) ->
    @options = @merge {}, @defaults, options
    this


  initGlobals: ->
    window.deadHollow = window.deadHollow || {
      pause: false
      solids: []
      movement:
        forward: 0
        backward: 0
        up: 0
      css:
        transform: Modernizr.prefixed 'transform'
      event:
        transitionEnd: transitionEnd()
    }


  addEvent: (element, event, callback, useCapture = false) ->
    element.addEventListener event, callback, useCapture
    element


  stop: () ->
    event.preventDefault() if event && event.preventDefault
    event


  fadeIn: (elements, complete) ->
    elements = [elements] unless elements instanceof Array
    fade = (element) ->
      element.classList.remove 'hide'
      element.classList.add 'show'
      element.style.opacity = 1
      element.style.visibility = 'visible'
      element

    fade element for element in elements

    if complete
      transitionEnd = @globals.event.transitionEnd
      @addEvent(elements[0], transitionEnd, callback = ->
        elements[0].removeEventListener(transitionEnd, callback, false)
        complete.call this
      )
    return


  fadeOut: (elements, complete) ->
    elements = [elements] unless elements instanceof Array
    fade = (element) ->
      element.classList.remove 'show'
      element.classList.add 'hide'
      element.style.opacity = 0
      element.style.visibility = 'hidden'
      element

    fade element for element in elements

    if complete
      transitionEnd = @globals.event.transitionEnd
      @addEvent(elements[0], transitionEnd, callback = ->
        elements[0].removeEventListener(transitionEnd, callback, false)
        complete.call this
      )
    return


  getIndex: (element) ->
    parseInt element.className.match(/\w*-(\d+)/)[1], 10


  setText: (element, text) ->
    if element.innerText
      element.innerText = text
    else
      element.textContent = text
    element


  flexcrollContent: (element) ->
    fleXenv.fleXcrollMain element.querySelector('.flexcroll')
    element


  merge: (target, extensions...) ->
    for extension in extensions
      for own property of extension
        target[property] = extension[property]
    target


(exports ? this).Base = Base
