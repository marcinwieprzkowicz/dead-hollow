// Generated by CoffeeScript 1.4.0

/*

Collision CoffeeScript class.
Really simple collision library, calculates the positions of solid element and doing some math stuff ;).
Provides two very useful methods: checkBetween & checkAll.

@author: Marcin Wieprzkowicz (marcin.wieprzkowicz@gmail.com)
*/


(function() {
  var Collision,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Collision = (function(_super) {

    __extends(Collision, _super);

    Collision.prototype.defaults = {
      element: {
        solids: '#map .solid'
      }
    };

    function Collision(options, mapPosition) {
      var solidElement, solidElements, solidElementsLength, solidIterator;
      this.mapPosition = mapPosition;
      Collision.__super__.constructor.apply(this, arguments);
      solidElements = document.querySelectorAll(this.options.element.solids);
      solidElementsLength = solidElements.length;
      solidIterator = 0;
      this.globals.solids = new Array(solidElementsLength);
      while (solidIterator < solidElementsLength) {
        solidElement = solidElements[solidIterator];
        solidElement.setAttribute('data-index', solidIterator);
        this.globals.solids[solidIterator] = new Solid(solidElement);
        solidIterator++;
      }
    }

    Collision.prototype.checkBetween = function(firstEl, secondEl, shiftX, shiftY) {
      var bottom, left, right, top;
      left = Math.max(firstEl.position.x - this.mapPosition.x - shiftX, secondEl.position.x);
      right = Math.min(firstEl.position.x + firstEl.width - this.mapPosition.x - shiftX, secondEl.position.x + secondEl.width);
      bottom = Math.max(firstEl.position.y - this.mapPosition.y - shiftY, secondEl.position.y);
      top = Math.min(firstEl.position.y + firstEl.height - this.mapPosition.y - shiftY, secondEl.position.y + secondEl.height);
      return left < right && bottom < top;
    };

    Collision.prototype.checkAll = function(element, elements, shiftX, shiftY) {
      var handle, i, length;
      if (elements == null) {
        elements = this.globals.solids;
      }
      handle = {
        status: false
      };
      length = elements.length - 1;
      i = 0;
      while (true) {
        if (this.checkBetween(element, elements[i], shiftX, shiftY)) {
          handle = {
            status: true,
            solid: elements[i]
          };
          break;
        } else if (i === length) {
          break;
        }
        i++;
      }
      return handle;
    };

    return Collision;

  })(Base);

  (typeof exports !== "undefined" && exports !== null ? exports : this).Collision = Collision;

}).call(this);
