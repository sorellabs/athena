(function(){
  var compose, curry, partial, uncurry, uncurryBind, flip, wrap, slice$ = [].slice;
  compose = function(){
    var fs, len;
    fs = arguments;
    len = fs.length;
    return function(){
      var result, i;
      result = arguments;
      i = len;
      while (i--) {
        result = [fs[i].apply(this, result)];
      }
      return result[0];
    };
  };
  curry = function(arity, f, initial){
    if (typeof arity === 'function') {
      initial = arguments[1];
      f = arity;
      arity = f.length;
    }
    return function(){
      var args;
      args = slice$.call(arguments);
      args = (initial || []).concat(args);
      if (args.length < arity) {
        return curry(arity, f, args);
      } else {
        return f.apply(this, args);
      }
    };
  };
  partial = function(f){
    var args;
    args = slice$.call(arguments, 1);
    return function(){
      var additionalArgs;
      additionalArgs = slice$.call(arguments);
      return f.apply(this, args.concat(additionalArgs));
    };
  };
  uncurry = function(f){
    return function(args){
      return f.apply(this, args);
    };
  };
  uncurryBind = function(f){
    return function(args){
      return f.call.apply(f, args);
    };
  };
  flip = function(f){
    throw Error('unimplemented');
  };
  wrap = function(wrapper, f){
    return function(){
      var args;
      args = slice$.call(arguments);
      return wrapper.apply(this, [f].concat(args));
    };
  };
  module.exports = {
    compose: compose,
    curry: curry,
    partial: partial,
    uncurry: uncurry,
    uncurryBind: uncurryBind,
    flip: flip,
    wrap: curry(wrap)
  };
}).call(this);
