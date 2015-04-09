!function(e){if("object"==typeof exports&&"undefined"!=typeof module)module.exports=e();else if("function"==typeof define&&define.amd)define([],e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.pg=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"D:\\xampp\\htdocs\\simple-touch\\scripts\\js\\lib\\SimpleTouch.js":[function(require,module,exports){
var PanListener, SimpleTouch, TapListener;

SimpleTouch = (function() {
  function SimpleTouch(node) {
    this.node = node;
    this._tapListeners = [];
    this._panListeners = [];
    if (window.navigator.msPointerEnabled) {
      this.touchDown = false;
      this.node.addEventListener("MSHoldVisual", function(e) {
        return e.preventDefault();
      }, false);
      this.node.addEventListener("contextmenu", function(e) {
        return e.preventDefault();
      }, false);
      this.node.addEventListener('MSPointerDown', (function(_this) {
        return function(event) {
          _this.touchDown = true;
          return _this._handleTouchStart();
        };
      })(this));
      this.node.addEventListener('MSPointerMove', (function(_this) {
        return function(event) {
          if (_this.touchDown === false) {
            return;
          }
          return _this._handleTouchMove();
        };
      })(this));
      this.node.addEventListener('MSPointerUp', (function(_this) {
        return function(event) {
          _this.touchDown = false;
          return _this._handleTouchEnd();
        };
      })(this));
    }
    this.node.addEventListener('touchstart', (function(_this) {
      return function(event) {
        return _this._handleTouchStart();
      };
    })(this));
    this.node.addEventListener('touchmove', (function(_this) {
      return function(event) {
        return _this._handleTouchMove();
      };
    })(this));
    this.node.addEventListener('touchend', (function(_this) {
      return function(event) {
        return _this._handleTouchEnd();
      };
    })(this));
    if (window.ontouchstart === void 0) {
      this.touchSimulateDown = false;
      this.node.addEventListener('mousedown', (function(_this) {
        return function(event) {
          _this.touchSimulateDown = true;
          return _this._handleTouchStart();
        };
      })(this));
      this.node.addEventListener('mousemove', (function(_this) {
        return function(event) {
          if (_this.touchSimulateDown === false) {
            return;
          }
          return _this._handleTouchMove();
        };
      })(this));
      this.node.addEventListener('mouseup', (function(_this) {
        return function(event) {
          _this.touchSimulateDown = false;
          return _this._handleTouchEnd();
        };
      })(this));
    }
  }

  SimpleTouch.prototype._handleTouchStart = function() {
    var listener, panListener, prospect, tapListener, _i, _j, _len, _len1;
    prospect = this._checkProspect(event.target, this._tapListeners);
    if (prospect !== false) {
      tapListener = this._tapListeners[prospect.id];
      event.listener = prospect;
      for (_i = 0, _len = tapListener.length; _i < _len; _i++) {
        listener = tapListener[_i];
        listener.callStart(event);
      }
    }
    prospect = this._checkProspect(event.target, this._panListeners);
    if (prospect !== false) {
      panListener = this._panListeners[prospect.id];
      event.listener = prospect;
      for (_j = 0, _len1 = panListener.length; _j < _len1; _j++) {
        listener = panListener[_j];
        listener.callStart(event);
      }
    }
  };

  SimpleTouch.prototype._handleTouchMove = function() {
    var listener, panListener, prospect, tapListener, _i, _j, _len, _len1;
    prospect = this._checkProspect(event.target, this._tapListeners);
    if (prospect !== false) {
      tapListener = this._tapListeners[prospect.id];
      event.listener = prospect;
      for (_i = 0, _len = tapListener.length; _i < _len; _i++) {
        listener = tapListener[_i];
        listener.callCancel(event);
      }
    }
    prospect = this._checkProspect(event.target, this._panListeners);
    if (prospect !== false) {
      panListener = this._panListeners[prospect.id];
      event.listener = prospect;
      for (_j = 0, _len1 = panListener.length; _j < _len1; _j++) {
        listener = panListener[_j];
        listener.callPan(event);
      }
    }
  };

  SimpleTouch.prototype._handleTouchEnd = function() {
    var listener, panListener, prospect, tapListener, _i, _j, _len, _len1;
    prospect = this._checkProspect(event.target, this._tapListeners);
    if (prospect !== false) {
      tapListener = this._tapListeners[prospect.id];
      event.listener = prospect;
      for (_i = 0, _len = tapListener.length; _i < _len; _i++) {
        listener = tapListener[_i];
        listener.callDone(event);
      }
    }
    prospect = this._checkProspect(event.target, this._panListeners);
    if (prospect !== false) {
      panListener = this._panListeners[prospect.id];
      event.listener = prospect;
      for (_j = 0, _len1 = panListener.length; _j < _len1; _j++) {
        listener = panListener[_j];
        listener.callEnd(event);
      }
    }
  };

  SimpleTouch.prototype._checkProspect = function(prospect, listeners) {
    while (prospect) {
      if (listeners[prospect.id] != null) {
        return prospect;
      }
      prospect = prospect.parentNode;
    }
    return false;
  };

  SimpleTouch.prototype.onTap = function(id) {
    var l;
    l = new TapListener();
    if (this._tapListeners[id] != null) {
      this._tapListeners[id].push(l);
      return l;
    }
    this._tapListeners[id] = [l];
    return l;
  };

  SimpleTouch.prototype.onPan = function(id) {
    var l;
    l = new PanListener();
    if (this._panListeners[id] != null) {
      this._panListeners[id].push(l);
      return l;
    }
    this._panListeners[id] = [l];
    return l;
  };

  return SimpleTouch;

})();

TapListener = (function() {
  function TapListener(milisec) {
    this.milisec = milisec != null ? milisec : 300;
    this._tapStart = false;
    this.touchPosX = this.touchTotalPosX = this.touchStartPosX = 0;
    this.touchPosY = this.touchTotalPosY = this.touchStartPosY = 0;
  }

  TapListener.prototype.onStart = function(cbStart) {
    this.cbStart = cbStart;
    return this;
  };

  TapListener.prototype.onCancel = function(cbCancel) {
    this.cbCancel = cbCancel;
    return this;
  };

  TapListener.prototype.onEnd = function(cbEnd) {
    this.cbEnd = cbEnd;
    return this;
  };

  TapListener.prototype.onDone = function(cbDone) {
    this.cbDone = cbDone;
    return this;
  };

  TapListener.prototype.onTap = function(cbTap) {
    this.cbTap = cbTap;
    return this;
  };

  TapListener.prototype.callStart = function(event) {
    event.startX = this.touchStartPosX = (event.clientX != null ? event.clientX : event.touches[0].clientX);
    event.startY = this.touchStartPosY = (event.clientY != null ? event.clientY : event.touches[0].clientY);
    if (this.cbStart != null) {
      this.cbStart(event);
    }
    this._tapStart = Date.now();
  };

  TapListener.prototype.callCancel = function(event) {
    event.movementX = (event.clientX != null ? event.clientX : event.touches[0].clientX) - this.touchPosX;
    event.movementY = (event.clientY != null ? event.clientY : event.touches[0].clientY) - this.touchPosY;
    event.startX = this.touchStartPosX;
    event.startY = this.touchStartPosY;
    this.touchPosX = (event.clientX != null ? event.clientX : event.touches[0].clientX);
    this.touchPosY = (event.clientY != null ? event.clientY : event.touches[0].clientY);
    this.touchTotalPosX += this.touchPosX;
    this.touchTotalPosY += this.touchPosY;
    event.totalX = this.touchTotalPosX = this.touchStartPosX - this.touchPosX;
    event.totalY = this.touchTotalPosY = this.touchStartPosY - this.touchPosY;
    event.time = Date.now() - this._tapStart;
    if (Math.abs(event.totalX) > 10 || Math.abs(event.totalY) > 10) {
      if (this.cbCancel != null) {
        this.cbCancel(event);
      }
      this.callEnd(event);
      this._tapStart = false;
    }
  };

  TapListener.prototype.callEnd = function(event) {
    event.startX = this.touchStartPosX;
    event.startY = this.touchStartPosY;
    event.totalX = this.touchTotalPosX;
    event.totalY = this.touchTotalPosY;
    if (this.cbEnd != null) {
      this.cbEnd(event);
    }
    this.touchPosX = this.touchTotalPosX = this.touchStartPosX = 0;
    this.touchPosY = this.touchTotalPosY = this.touchStartPosY = 0;
  };

  TapListener.prototype.callDone = function(event) {
    event.time = Date.now() - this._tapStart;
    this.callEnd(event);
    if (this._tapStart !== false) {
      if (this.cbDone != null) {
        this.cbDone(event);
      }
      if (event.time < this.milisec) {
        this.callTap(event);
        this._tapStart = false;
      }
    }
  };

  TapListener.prototype.callTap = function(event) {
    if (this.cbTap != null) {
      this.cbTap(event);
    }
  };

  return TapListener;

})();

PanListener = (function() {
  function PanListener() {
    this.touchPosX = this.touchTotalPosX = this.touchStartPosX = 0;
    this.touchPosY = this.touchTotalPosY = this.touchStartPosY = 0;
  }

  PanListener.prototype.onStart = function(cbStart) {
    this.cbStart = cbStart;
    return this;
  };

  PanListener.prototype.onEnd = function(cbEnd) {
    this.cbEnd = cbEnd;
    return this;
  };

  PanListener.prototype.onPan = function(cbPan) {
    this.cbPan = cbPan;
    return this;
  };

  PanListener.prototype.callStart = function(event) {
    event.startX = this.touchStartPosX = (event.clientX != null ? event.clientX : event.touches[0].clientX);
    event.startY = this.touchStartPosY = (event.clientY != null ? event.clientY : event.touches[0].clientY);
    if (this.cbStart != null) {
      this.cbStart(event);
    }
  };

  PanListener.prototype.callEnd = function(event) {
    event.startX = this.touchStartPosX;
    event.startY = this.touchStartPosY;
    event.totalX = this.touchTotalPosX;
    event.totalY = this.touchTotalPosY;
    if (this.cbEnd != null) {
      this.cbEnd(event);
    }
    this.touchPosX = this.touchTotalPosX = this.touchStartPosX = 0;
    this.touchPosY = this.touchTotalPosY = this.touchStartPosY = 0;
  };

  PanListener.prototype.callPan = function(event) {
    event.movementX = (event.clientX != null ? event.clientX : event.touches[0].clientX) - this.touchPosX;
    event.movementY = (event.clientY != null ? event.clientY : event.touches[0].clientY) - this.touchPosY;
    event.startX = this.touchStartPosX;
    event.startY = this.touchStartPosY;
    this.touchPosX = (event.clientX != null ? event.clientX : event.touches[0].clientX);
    this.touchPosY = (event.clientY != null ? event.clientY : event.touches[0].clientY);
    this.touchTotalPosX += this.touchPosX;
    this.touchTotalPosY += this.touchPosY;
    event.totalX = this.touchTotalPosX = this.touchStartPosX - this.touchPosX;
    event.totalY = this.touchTotalPosY = this.touchStartPosY - this.touchPosY;
    if (this.cbPan != null) {
      this.cbPan(event);
    }
  };

  return PanListener;

})();

module.exports = new SimpleTouch(document.body);

},{}]},{},["D:\\xampp\\htdocs\\simple-touch\\scripts\\js\\lib\\SimpleTouch.js"])("D:\\xampp\\htdocs\\simple-touch\\scripts\\js\\lib\\SimpleTouch.js")
});