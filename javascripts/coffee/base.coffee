###

Base CoffeeScript class based on: https://gist.github.com/rpflorence/3681784.
The most important functionality is 'setOptions' - brings back good memories of MooTools :).
It also contains many useful functions.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class Base

  defaults: {}


  constructor: (options) ->
    @setOptions options
    @cssTransform = Modernizr.prefixed 'transform'


  setOptions: (options) ->
    @options = @merge {}, @defaults, options
    this


  addEvent: (element, event, callback, useCapture = false) ->
    element.addEventListener event, callback, useCapture
    element


  preventDefault: (event) ->
    event.preventDefault() if event && event.preventDefault
    event


  fadeIn: (element) ->
    element.classList.remove 'hide'
    element.classList.add 'show'
    element.style.opacity = 1
    element.style.visibility = 'visible'
    element


  fadeOut: (element) ->
    element.classList.remove 'show'
    element.classList.add 'hide'
    element.style.opacity = 0
    element.style.visibility = 'hidden'
    element


  setText: (element, text) ->
    if element.innerText
      element.innerText = text
    else
      element.textContent = text
    element


  getTransitionEndName: ->
    transitionEndEventNames =
      'WebkitTransition' : 'webkitTransitionEnd'
      'MozTransition'    : 'transitionend'
      'OTransition'      : 'oTransitionEnd'
      'msTransition'     : 'MSTransitionEnd'
      'transition'       : 'transitionend'
    transitionEndEventNames[ Modernizr.prefixed 'transition' ]


  flexcrollContent: (element) ->
    fleXenv.fleXcrollMain element.querySelector('.flexcroll')
    element


  merge: (target, extensions...) ->
    for extension in extensions
      for own property of extension
        target[property] = extension[property]
    target


(exports ? this).Base = Base
