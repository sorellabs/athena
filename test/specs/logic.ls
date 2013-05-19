spec = (require 'brofist')!
{for-all, sized, data} = require 'claire'
Any = (sized -> 10) data.Any

{ _or, _and, _not } = require '../../lib/logic'
f1 = (a) -> a
f2 = (_, a) -> a
f3 = (_, __, a) -> a

module.exports = spec '{} logic' (it, spec) ->

  spec 'or()' ->
    it 'or(f, g, h)(a) = f(a) || g(a) || h(a)' do
      for-all(Any, Any, Any) .satisfy (a, b, c) ->
        _or(f1, f2, f3)(a, b, c) == (a or b or c)

      .classify (a, b, c) -> "#{!!a} #{!!b} #{!!c}"
      .as-test { times: 1000 }

  spec 'and()' ->
    it 'and(f, g, h)(a) = f(a) && g(a) && h(a)' do
      for-all(Any, Any, Any) .satisfy (a, b, c) ->
        _and(f1, f2, f3)(a, b, c) == (a and b and c)

      .classify (a, b, c) -> !!a
      .as-test { times: 1000 }

  spec 'not()' ->
    it 'not(f)(a) = !f(a)' do
      for-all(Any) .satisfy (a) ->
        _not(f1)(a) is (not a)

      .classify (a) -> !!a
      .as-test!
