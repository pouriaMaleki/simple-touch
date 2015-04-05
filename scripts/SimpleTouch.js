!function(e){if("object"==typeof exports&&"undefined"!=typeof module)module.exports=e();else if("function"==typeof define&&define.amd)define([],e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.pg=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"D:\\xampp\\htdocs\\simple-touch\\scripts\\js\\lib\\SimpleTouch.js":[function(require,module,exports){
var PanListener, SimpleTouch, TapListener;

SimpleTouch = (function() {
  function SimpleTouch(node) {
    this.node = node;
    this._tapListeners = [];
    this._panListeners = [];
    if (window.navigator.msPointerEnabled) {
      this.node.addEventListener("MSPointerDown", (function(_this) {
        return function(event) {
          var listener, prospect, tapListener, _i, _len;
          prospect = _this._checkProspect(event.target, _this._tapListeners);
          if (prospect !== false) {
            tapListener = _this._tapListeners[prospect.id];
            event.listener = prospect;
            for (_i = 0, _len = tapListener.length; _i < _len; _i++) {
              listener = tapListener[_i];
              listener.callStart(event);
            }
          }
        };
      })(this));
      this.node.addEventListener("MSPointerMove", (function(_this) {
        return function(event) {
          var listener, prospect, tapListener, _i, _len;
          prospect = _this._checkProspect(event.target, _this._tapListeners);
          if (prospect !== false) {
            tapListener = _this._tapListeners[prospect.id];
            event.listener = prospect;
            for (_i = 0, _len = tapListener.length; _i < _len; _i++) {
              listener = tapListener[_i];
              listener.callCancel(event);
            }
          }
        };
      })(this));
      this.node.addEventListener("MSPointerUp", (function(_this) {
        return function(event) {
          var listener, prospect, tapListener, _i, _len;
          prospect = _this._checkProspect(event.target, _this._tapListeners);
          if (prospect !== false) {
            tapListener = _this._tapListeners[prospect.id];
            event.listener = prospect;
            for (_i = 0, _len = tapListener.length; _i < _len; _i++) {
              listener = tapListener[_i];
              listener.callDone(event);
            }
          }
        };
      })(this));
    }
    this.node.addEventListener('touchstart', (function(_this) {
      return function(event) {
        var listener, panListener, prospect, tapListener, _i, _j, _len, _len1;
        prospect = _this._checkProspect(event.target, _this._tapListeners);
        if (prospect !== false) {
          tapListener = _this._tapListeners[prospect.id];
          event.listener = prospect;
          for (_i = 0, _len = tapListener.length; _i < _len; _i++) {
            listener = tapListener[_i];
            listener.callStart(event);
          }
        }
        prospect = _this._checkProspect(event.target, _this._panListeners);
        if (prospect !== false) {
          panListener = _this._panListeners[prospect.id];
          event.listener = prospect;
          for (_j = 0, _len1 = panListener.length; _j < _len1; _j++) {
            listener = panListener[_j];
            listener.callStart(event);
          }
        }
      };
    })(this));
    this.node.addEventListener('touchmove', (function(_this) {
      return function(event) {
        var listener, panListener, prospect, tapListener, _i, _j, _len, _len1;
        prospect = _this._checkProspect(event.target, _this._tapListeners);
        if (prospect !== false) {
          tapListener = _this._tapListeners[prospect.id];
          event.listener = prospect;
          for (_i = 0, _len = tapListener.length; _i < _len; _i++) {
            listener = tapListener[_i];
            listener.callCancel(event);
          }
        }
        prospect = _this._checkProspect(event.target, _this._panListeners);
        if (prospect !== false) {
          panListener = _this._panListeners[prospect.id];
          event.listener = prospect;
          for (_j = 0, _len1 = panListener.length; _j < _len1; _j++) {
            listener = panListener[_j];
            listener.callPan(event);
          }
        }
      };
    })(this));
    this.node.addEventListener('touchend', (function(_this) {
      return function(event) {
        var listener, panListener, prospect, tapListener, _i, _j, _len, _len1;
        prospect = _this._checkProspect(event.target, _this._tapListeners);
        if (prospect !== false) {
          tapListener = _this._tapListeners[prospect.id];
          event.listener = prospect;
          for (_i = 0, _len = tapListener.length; _i < _len; _i++) {
            listener = tapListener[_i];
            listener.callDone(event);
          }
        }
        prospect = _this._checkProspect(event.target, _this._panListeners);
        if (prospect !== false) {
          panListener = _this._panListeners[prospect.id];
          event.listener = prospect;
          for (_j = 0, _len1 = panListener.length; _j < _len1; _j++) {
            listener = panListener[_j];
            listener.callEnd(event);
          }
        }
      };
    })(this));
  }

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
    if (this.cbStart != null) {
      this.cbStart(event);
    }
    this._tapStart = Date.now();
  };

  TapListener.prototype.callCancel = function(event) {
    event.time = Date.now() - this._tapStart;
    if (this.cbCancel != null) {
      this.cbCancel(event);
    }
    this.callEnd(event);
    this._tapStart = false;
  };

  TapListener.prototype.callEnd = function(event) {
    if (this.cbEnd != null) {
      this.cbEnd(event);
    }
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
    event.startX = this.touchStartPosX = event.touches[0].clientX;
    event.startY = this.touchStartPosY = event.touches[0].clientY;
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
    var totalX;
    event.movementX = event.touches[0].clientX - this.touchPosX;
    event.movementY = event.touches[0].clientY - this.touchPosY;
    event.startX = this.touchStartPosX;
    event.startY = this.touchStartPosY;
    totalX = this.touchPosX = event.touches[0].clientX;
    this.touchPosY = event.touches[0].clientY;
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