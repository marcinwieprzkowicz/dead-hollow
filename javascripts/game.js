// Generated by CoffeeScript 1.4.0

/*

Game CoffeeScript class.

"One Class to rule them all,
One Class to find them,
One Class to bring them all
and in the darkness bind them."

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)
*/


(function() {
  var Game,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Game = (function(_super) {

    __extends(Game, _super);

    Game.prototype.defaults = {
      game: {
        overlay: '#game .overlay',
        start: '#start-game'
      }
    };

    function Game(options, menu) {
      this.menu = menu;
      Game.__super__.constructor.apply(this, arguments);
      this.paused = null;
      this.element = {
        game: {
          overlay: document.querySelector(this.options.game.overlay),
          start: document.querySelector(this.options.game.start)
        }
      };
      this.initAudio();
    }

    Game.prototype.start = function() {
      var _this = this;
      this.fadeOut(this.element.game.overlay);
      this.fadeOut(this.menu.element.main.element);
      if (this.paused === null) {
        this.map = new Map({}, this);
        this.character = new Character({
          id: 'character',
          klass: 'visualization'
        }, this.audio);
        this.map.add(this.character);
        this.control = new Control({}, this, this.map);
        this.control.addKeyboardEvents();
        if (Modernizr.touch) {
          this.control.showTouchItems();
          this.control.addControlEvents();
        }
      }
      setTimeout(function() {
        return _this.setText(_this.element.game.start, 'Resume');
      }, 600);
      this.paused = false;
      this.character.clear();
      this.map.animationsStopped(false);
      this.animation = setInterval(function() {
        _this.map.draw();
      }, 50);
    };

    Game.prototype.pause = function() {
      this.paused = true;
      this.character.domEl.classList.add('paused');
      this.map.animationsStopped(true);
      clearInterval(this.animation);
    };

    Game.prototype.reset = function() {
      var _this = this;
      this.map.setDefaultPosition();
      this.map.closeDoors();
      this.map.clearAnimation('up');
      this.map.clearAnimation('right');
      this.map.clearAnimation('left');
      setTimeout(function() {
        _this.setText(_this.element.game.start, 'Start game');
        return _this.map.draw();
      }, 1000);
    };

    Game.prototype.theEnd = function() {
      this.pause();
      this.reset();
      this.setText(this.menu.element.theEnd.header, 'The end');
      this.menu.element.theEnd.congratulations.style.display = 'block';
      this.fadeIn(this.element.game.overlay);
      this.fadeIn(this.menu.element.section.credits);
      this.flexcrollContent(this.menu.element.section.credits);
    };

    Game.prototype.gameOver = function(speed) {
      var _this = this;
      this.character.domEl.classList.add('death');
      this.character.domEl.style[this.cssTransform] = "translate3d(0, " + (Math.abs(speed) * 20) + "px, 0)";
      setTimeout(function() {
        _this.pause();
        _this.reset();
        return _this.fadeIn(_this.menu.element.section.gameOver);
      }, 1000);
    };

    Game.prototype.aboutMe = function() {
      this.pause();
      this.reset();
      this.fadeIn(this.element.game.overlay);
      this.fadeIn(this.menu.element.section.aboutMe);
      this.flexcrollContent(this.menu.element.section.aboutMe);
    };

    Game.prototype.initAudio = function() {
      if (Modernizr.ismobile) {
        buzz.defaults.preload = 'none';
      }
      buzz.defaults.formats = ['ogg', 'm4a'];
      buzz.defaults.volume = Modernizr.ismobile ? 0 : 15;
      this.audio = {
        background: new buzz.sound('audio/background', {
          autoplay: !Modernizr.ismobile,
          loop: true,
          volume: 10
        }),
        running: new buzz.sound('audio/running', {
          loop: true
        }),
        landing: new buzz.sound('audio/landing', {
          loop: false
        }),
        openingDoors: new buzz.sound('audio/opening-doors', {
          loop: false
        })
      };
      this.sounds = new buzz.group([this.audio.running, this.audio.landing, this.audio.openingDoors]);
    };

    return Game;

  })(Base);

  (typeof exports !== "undefined" && exports !== null ? exports : this).Game = Game;

}).call(this);
