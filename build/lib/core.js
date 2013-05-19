(function(){
  var noop, k, id;
  noop = function(){};
  k = function(x){
    return function(){
      return x;
    };
  };
  id = function(x){
    return x;
  };
  module.exports = {
    noop: noop,
    k: k,
    id: id
  };
}).call(this);
