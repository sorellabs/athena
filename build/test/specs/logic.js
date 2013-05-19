(function(){
  var spec, ref$, forAll, sized, data, Any, _or, _and, _not, f1, f2, f3;
  spec = require('brofist')();
  ref$ = require('claire'), forAll = ref$.forAll, sized = ref$.sized, data = ref$.data;
  Any = sized(function(){
    return 10;
  })(data.Any);
  ref$ = require('../../lib/logic'), _or = ref$._or, _and = ref$._and, _not = ref$._not;
  f1 = function(a){
    return a;
  };
  f2 = function(_, a){
    return a;
  };
  f3 = function(_, __, a){
    return a;
  };
  module.exports = spec('{} logic', function(it, spec){
    spec('or()', function(it){
      return it('or(f, g, h)(a) = f(a) || g(a) || h(a)', forAll(Any, Any, Any).satisfy(function(a, b, c){
        return _or(f1, f2, f3)(a, b, c) === (a || b || c);
      }).classify(function(a, b, c){
        return !!a + " " + !!b + " " + !!c;
      }).asTest({
        times: 1000
      }));
    });
    spec('and()', function(it){
      return it('and(f, g, h)(a) = f(a) && g(a) && h(a)', forAll(Any, Any, Any).satisfy(function(a, b, c){
        return _and(f1, f2, f3)(a, b, c) === (a && b && c);
      }).classify(function(a, b, c){
        return !!a;
      }).asTest({
        times: 1000
      }));
    });
    return spec('not()', function(it){
      return it('not(f)(a) = !f(a)', forAll(Any).satisfy(function(a){
        return _not(f1)(a) === !a;
      }).classify(function(a){
        return !!a;
      }).asTest());
    });
  });
}).call(this);
