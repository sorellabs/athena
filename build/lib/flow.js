(function(){
  var curry, either, Unless, limit, once, Until, When;
  curry = require('./higher-order').curry;
  either = function(pred, consequent, alternate){
    return function(){
      switch (false) {
      case !pred.apply(this, arguments):
        return consequent.apply(this, arguments);
      default:
        return alternate.apply(this, arguments);
      }
    };
  };
  Unless = function(pred, consequent){
    if (!pred.apply(this, arguments)) {
      return consequent.apply(this, arguments);
    }
  };
  limit = function(times, f){
    return function(){
      if (--times < 0) {
        return f.apply(this, arguments);
      }
    };
  };
  once = limit(1);
  Until = function(pred, f){
    var call;
    call = true;
    return function(){
      if (call && (call = !pred.apply(this, arguments))) {
        return f.apply(this, arguments);
      }
    };
  };
  When = function(pred, f){
    var call;
    call = false;
    return function(){
      switch (false) {
      case !call:
        return f.apply(this, arguments);
      case !pred.apply(this, arguments):
        call = true;
        return f.apply(this, arguments);
      }
    };
  };
  module.exports = {
    either: either,
    unless: curry(Unless),
    limit: limit,
    once: once,
    until: curry(Until),
    when: curry(When)
  };
}).call(this);
