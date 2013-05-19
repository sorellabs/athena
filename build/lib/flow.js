(function(){
  var curry, either, Unless, limit, once, Until, When, slice$ = [].slice;
  curry = require('./higher-order').curry;
  either = curry(4, function(pred, consequent, alternate){
    var xs;
    xs = slice$.call(arguments, 3);
    switch (false) {
    case !pred.call(this, xs):
      return consequent.call(this, xs);
    default:
      return alternate.call(this, xs);
    }
  });
  Unless = curry(3, function(pred, consequent){
    var xs;
    xs = slice$.call(arguments, 2);
    if (!pred.call(this, xs)) {
      return consequent.call(this, xs);
    }
  });
  limit = curry(function(times, f){
    return function(){
      if (--times >= 0) {
        return f.apply(this, arguments);
      }
    };
  });
  once = limit(1);
  Until = curry(function(pred, f){
    var call;
    call = true;
    return function(){
      if (call && (call = !pred.apply(this, arguments))) {
        return f.apply(this, arguments);
      }
    };
  });
  When = curry(function(pred, f){
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
  });
  module.exports = {
    either: either,
    unless: Unless,
    _unless: Unless,
    limit: limit,
    once: once,
    until: Until,
    _until: Until,
    when: When,
    _when: When
  };
}).call(this);
