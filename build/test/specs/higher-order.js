(function(){
  var spec, ref$, forAll, sized, data, Int, compose, curry, partial, uncurry, uncurryBind, flip, wrap, id, x, slice$ = [].slice;
  spec = require('brofist')();
  ref$ = require('claire'), forAll = ref$.forAll, sized = ref$.sized, data = ref$.data;
  Int = data.Int;
  ref$ = require('../../lib/higher-order'), compose = ref$.compose, curry = ref$.curry, partial = ref$.partial, uncurry = ref$.uncurry, uncurryBind = ref$.uncurryBind, flip = ref$.flip, wrap = ref$.wrap;
  id = require('../../lib/core').id;
  x = function(t){
    return t.disable();
  };
  module.exports = spec('{} higher-order', function(it, spec){
    spec('compose()', function(it){
      var f, g, h;
      f = (function(it){
        return it + 1;
      });
      g = (function(it){
        return it - 2;
      });
      h = (function(it){
        return it * 3;
      });
      it('Given `f: a → b` and `g: b → c`, then `(g . f): a → c`', forAll(Int).satisfy(function(a){
        return compose(g, f)(a) === g(f(a));
      }).asTest());
      it('associativity: `f . (g . h)` = `(f . g) . h`', forAll(Int).satisfy(function(a){
        return compose(f, compose(g, h))(a) === compose(compose(f, g), h)(a);
      }).asTest());
      it('left identity: `id . f` = f`', forAll(Int).satisfy(function(a){
        return compose(id, f)(a) === f(a);
      }).asTest());
      return it('right identity: `f . id` = f`', forAll(Int).satisfy(function(a){
        return compose(f, id)(a) === f(a);
      }).asTest());
    });
    spec('curry()', function(it){
      var add, sum;
      add = function(a, b){
        return a + b;
      };
      sum = function(){
        var as;
        as = slice$.call(arguments);
        return as.reduce(curry$(function(x$, y$){
          return x$ + y$;
        }), 0);
      };
      it('Given `f: (a, b) → c`, a curried form should be `f: a → b → c`', forAll(Int, Int).satisfy(function(a, b){
        return add(a, b) === curry(add)(a)(b);
      }).asTest());
      it('Should allow specifying arity for variadic functions.', forAll(Int, Int, Int).satisfy(function(a, b, c){
        return curry(3, sum)(a)(b)(c) === sum(a, b, c);
      }).asTest());
      it('Should allow more than one argument applied at a time.', forAll(Int, Int, Int).satisfy(function(a, b, c){
        var ref$;
        return curry(3, sum)(a, b)(c) === (ref$ = curry(3, sum)(a)(b, c)) && ref$ === sum(a, b, c);
      }).asTest());
      return it('Should accept initial arguments as an array.', forAll(Int, Int, Int).satisfy(function(a, b, c){
        return curry(3, sum, [a])(b)(c) === sum(a, b, c);
      }).asTest());
    });
    spec('partial()', function(it){
      var add;
      add = function(a, b, c){
        return a + b + (c || 0);
      };
      return it('For a function `f: (a..., b...) → c`, should yield `f: (b...) → c`', function(){
        return forAll(Int, Int).satisfy(function(a, b){
          return partial(add, 1)(2) === add(1, 2, 0);
        }).asTest();
      });
    });
    spec('uncurry()', function(it){
      var sum;
      sum = function(){
        var as;
        as = slice$.call(arguments);
        return as.reduce(curry$(function(x$, y$){
          return x$ + y$;
        }), 0);
      };
      return it('Should convert an `f: (a... -> b)` into `f: [a] -> b`', function(){
        return forAll(Int, Int, Int).satisfy(function(a, b, c){
          return uncurry(sum)([a, b, c]) === sum(a, b, c);
        }).asTest();
      });
    });
    spec('uncurry-bind()', function(it){
      var sum, usum;
      sum = function(){
        var as;
        as = slice$.call(arguments);
        return as.reduce(curry$(function(x$, y$){
          return x$ + y$;
        }), this.head);
      };
      usum = uncurryBind(sum);
      return it('Should convert an `f: (a... -> b)` into `f: [this, a...] -> b`', forAll(Int, Int).satisfy(function(a, b){
        return usum([
          {
            head: 1
          }, 2, 3
        ]) === sum.call({
          head: 1
        }, 2, 3);
      }).asTest());
    });
    spec('flip()', function(it){
      x(it('Should return a function of the same length.'));
      x(it('flip(f)(b)(a) = f(a, b).'));
      return x(it('flip(flip(f)(b))(a) = flip(a, b).'));
    });
    return spec('wrap()', function(it){
      var add, plus1;
      add = curry$(function(x$, y$){
        return x$ + y$;
      });
      plus1 = function(f, a){
        return f(a, 1);
      };
      return it('Should pass the wrapped function as first argument.', forAll(Int).satisfy(function(a){
        return wrap(plus1, add)(a) === add(a, 1);
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
