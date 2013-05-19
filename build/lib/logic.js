(function(){
  var Or, And, Not;
  Or = function(){
    var fs;
    fs = arguments;
    return function(){
      var i$, ref$, len$, f, result;
      for (i$ = 0, len$ = (ref$ = fs).length; i$ < len$; ++i$) {
        f = ref$[i$];
        result = f.apply(this, arguments);
        if (result) {
          return result;
        }
      }
      return result;
    };
  };
  And = function(){
    var fs;
    fs = arguments;
    return function(){
      var i$, ref$, len$, f, result;
      for (i$ = 0, len$ = (ref$ = fs).length; i$ < len$; ++i$) {
        f = ref$[i$];
        result = f.apply(this, arguments);
        if (!result) {
          return result;
        }
      }
      return result;
    };
  };
  Not = function(f){
    return function(){
      return !f.apply(this, arguments);
    };
  };
  module.exports = {
    or: Or,
    _or: Or,
    and: And,
    _and: And,
    not: Not,
    _not: Not
  };
}).call(this);
