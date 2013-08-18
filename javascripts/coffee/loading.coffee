###

Loading CoffeeScript class based on: http://modernizr.com.
Checks all the necessary features to run the game in browser.
Loads files via yepnope.js.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)

###


class Loading extends Base

  message:
    loadingDescription:
      checkingBrowser: 'Checking your browser...'
      loadingGame: 'Loading files...'
    feature:
      multiplebgs: 'multiple backgrounds'
      opacity: 'opacity'
      rgba: 'RGBA'
      cssanimations: 'CSS animations'
      csstransitions: 'CSS transitions'
      hascsstransforms3d: 'CSS transforms 3D'


  files: ['javascripts/lib/buzz.js',
        'javascripts/lib/keypress.js',
        'javascripts/solid.js',
        'javascripts/character.js',
        'javascripts/collision.js',
        'javascripts/control.js',
        'javascripts/platform.js',
        'javascripts/moving-platform.js',
        'javascripts/map.js',
        'javascripts/game.js',
        'stylesheets/character-sprites.css',
        'stylesheets/game.css']


  images: ['images/backgrounds/base-1.jpg',
        'images/backgrounds/base-2.jpg',
        'images/backgrounds/base-3.jpg',
        'images/backgrounds/border.png',
        'images/backgrounds/box.png',
        'images/backgrounds/door-leafs.png',
        'images/backgrounds/grating.png',
        'images/backgrounds/lighting.png',
        'images/backgrounds/pipelines.png',
        'images/backgrounds/platform.png',
        'images/backgrounds/trellis.png',
        'images/backgrounds/wall-clear.png',
        'images/backgrounds/wall-door.png',
        'images/backgrounds/wall.png',
        'images/character-sprites.png',
        'images/controls-sprites.png',
        'images/icons.png',
        'images/info-icon.png']


  features: ['multiplebgs',
            'opacity',
            'rgba',
            'cssanimations',
            'csstransitions',
            'hascsstransforms3d']


  constructor: ->
    steps = @features.length + @files.length + @images.length

    @progress =
      value: 0
      loaded: 0
      steps: steps
      step: parseFloat (100 / steps).toFixed(10)

    @menu = document.getElementById 'menu'
    @featuresTest = document.getElementById 'features-test'
    @errorOccured = document.getElementById 'error-occured'

    @element =
      featuresTest:
        progressBar: @featuresTest.querySelector '.progressBar'
        description: @featuresTest.querySelector '.description'
      errorOccured:
        description: @errorOccured.querySelector '.description'
      externalLinks: document.querySelectorAll 'a[rel="external"]'
      musicVolume: document.querySelectorAll '.musicVolume'

    @setText @element.featuresTest.description, @message.loadingDescription.checkingBrowser

    @externalLinks()
    @preventScrolling() if Modernizr.touch
    @addCustomTests()
    @hideMusicVolume() if Modernizr.ismobile

    @checkFeature 0


  externalLinks: ->
    link.target = '_blank' for link in @element.externalLinks
    return


  preventScrolling: ->
    @addEvent document, 'touchmove', (event) =>
      @stop event
    return


  addCustomTests: ->
    # custom csstransforms3d test, because Modernizr csstransforms3d doesn't work properly on linux
    Modernizr.addTest 'hascsstransforms3d', ->
      transforms =
        webkitTransform:  '-webkit-transform'
        OTransform:       '-o-transform'
        msTransform:      '-ms-transform'
        MozTransform:     '-moz-transform'
        transform:        'transform'

      el = document.createElement 'p'
      document.body.insertBefore el, null

      for t of transforms
        if typeof el.style[t] != 'undefined'
          el.style[t] = 'translate3d(1px, 1px, 1px)'
          has3d = window.getComputedStyle(el).getPropertyValue(transforms[t])

      document.body.removeChild el
      typeof has3d != 'undefined' && has3d.length && has3d != 'none'

    # is mobile
    Modernizr.addTest 'ismobile', ->
      navi = navigator.userAgent || navigator.vendor || window.opera
      /(android|ipad|playbook|silk|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino/i.test(navi) || /1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-/i.test(navi.substr(0, 4))
    return


  hideMusicVolume: ->
    element.style.display = 'none' for element in @element.musicVolume
    return


  checkFeature: (index) ->
    property = @features[index]
    featuresLength = @features.length

    if Modernizr.hasOwnProperty(property) && Modernizr[property]
      @updateProgress()
      index++

      if index == featuresLength
        @loadImages()
        @loadFiles()
      else
        @checkFeature index
    else
      @showProblems 'feature', property
    return


  updateProgress: ->
    @progress.value += @progress.step
    @progress.loaded++

    # all features checked & files loaded
    if @progress.loaded == @progress.steps
      @progress.value = 100

      setTimeout(=>
        @fadeOut @featuresTest
        @fadeOut @errorOccured
        @fadeIn @menu

        new Menu()
      , 400)

    @element.featuresTest.progressBar.style.width = "#{@progress.value}%"
    return


  showProblems: (type, detail) ->
    switch type
      when 'feature'
        @element.errorOccured.description.innerHTML = "Your browser doesn't support <strong>#{@message.feature[detail]}</strong>.<br />Update your browser or install new to start the game."

    @fadeOut @featuresTest
    setTimeout(=>
      @fadeIn @errorOccured
    , 600)
    return


  loadImages: ->
    new preLoader @images,
      onProgress: (src, imageEl, index) => @updateProgress()
    return


  loadFiles: ->
    @setText @element.featuresTest.description, @message.loadingDescription.loadingGame

    Modernizr.load [
      test: Modernizr.classlist
      nope: 'javascripts/shim/classList.min.js' # Thank you Eli Grey
    ,
      test: Modernizr.raf
      nope: 'javascripts/shim/requestAnimationFrame.js'
    ,
      test: Modernizr.multiplebgs && Modernizr.opacity && Modernizr.rgba && Modernizr.cssanimations && Modernizr.csstransitions && Modernizr.hascsstransforms3d
      yep : @files
      callback: (url, result, key) =>
        @updateProgress() if result
    ]
    return


(exports ? this).Loading = Loading
