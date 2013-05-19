(function(){
  var spec, claire, forAll, sized, Any, ref$, noop, k, id, Value;
  spec = require('brofist')();
  claire = require('claire'), forAll = claire.forAll, sized = claire.sized;
  Any = claire.data.Any;
  ref$ = require('../../lib/core'), noop = ref$.noop, k = ref$.k, id = ref$.id;
  Value = sized(function(){
    return 10;
  })(Any);
  module.exports = spec('{} core', function(it, spec){
    spec('noop()', function(it){
      return it('Should do nothing', function(){
        return forAll(Value).satisfy(function(a){
          return noop(a) === void 8;
        }).asTest();
      });
    });
    spec('k()', function(it){
      it('When applied to X should return a function', forAll(Value).satisfy(function(a){
        return typeof k(a) === 'function';
      }).asTest());
      return it('When applied to another argument, should return the first.', forAll(Value, Value).given(curry$(function(x$, y$){
        return x$ !== y$;
      })).satisfy(function(a, b){
        return k(a)(b) === a;
      }).asTest());
    });
    return spec('id()', function(it){
      return it('When applied to X, should return X', forAll(Value).satisfy(function(a){
        return id(a) === a;
      }).asTest());
    });
  });
  function curry$(f, bound){
    var context,
    _curry = function(args) {
      return f.length > 1 ? function(){
        var params = args ? args.concat() : [];
        context = bound ? context || this : this;
        return params.push.apply(params, arguments) <
            f.length && arguments.length ?
          _curry.call(context, params) : f.apply(context, params);
      } : f;
    };
    return _curry();
  }
}).call(this);
