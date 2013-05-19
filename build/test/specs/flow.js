(function(){
  var spec, ref$, forAll, data, expect, Bool, Int, either, _unless, limit, once, _until, _when, pos, neg;
  spec = require('brofist')();
  ref$ = require('claire'), forAll = ref$.forAll, data = ref$.data;
  expect = require('chai').expect;
  Bool = data.Bool, Int = data.Int;
  ref$ = require('../../lib/flow'), either = ref$.either, _unless = ref$._unless, limit = ref$.limit, once = ref$.once, _until = ref$._until, _when = ref$._when;
  pos = function(a){
    return Math.abs(a);
  };
  neg = function(a){
    return -Math.abs(a);
  };
  module.exports = spec('{} flow', function(it, spec){
    spec('either()', function(it){
      return it('either(p, f, g)(a) = if p(a) then f(a) else g(a).', forAll(Bool, Int).satisfy(function(a, b){
        return either(function(){
          return a;
        }, pos, neg)(b) === (a
          ? pos(b)
          : neg(b));
      }).asTest());
    });
    spec('unless()', function(it){
      return it('unless(p, f)(a) = if not p(a) then f(a).', forAll(Bool, Int).satisfy(function(a, b){
        return _unless(function(){
          return a;
        }, pos)(b) === (!a ? pos(b) : void 8);
      }).asTest());
    });
    spec('limit()', function(it){
      return it('Should return the value if invocations < limit.', function(){
        var p, xs;
        p = limit(2, pos);
        xs = [p(1), p(2), p(3)];
        return expect(xs).to.deep.equal([1, 2, void 8]);
      });
    });
    spec('once()', function(it){
      return it('Should return the value only in the first invocation.', function(){
        var p, xs;
        p = once(pos);
        xs = [p(1), p(2)];
        return expect(xs).to.deep.equal([1, void 8]);
      });
    });
    spec('until()', function(it){
      return it('Should only yield values before the predicate holds.', function(){
        var p, xs;
        p = _until((function(it){
          return it > 2;
        }), pos);
        xs = [p(1), p(2), p(3), p(0)];
        return expect(xs).to.deep.equal([1, 2, void 8, void 8]);
      });
    });
    return spec('when()', function(it){
      return it('Should only yield values after the predicate holds.', function(){
        var p, xs;
        p = _when((function(it){
          return it > 2;
        }), pos);
        xs = [p(1), p(2), p(3), p(0)];
        return expect(xs).to.deep.equal([void 8, void 8, 3, 0]);
      });
    });
  });
}).call(this);
