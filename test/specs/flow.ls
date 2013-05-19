spec = (require 'brofist')!
{for-all, data} = require 'claire'
{expect} = require 'chai'
{Bool, Int} = data

{ either, _unless, limit, once, _until, _when } = require '../../lib/flow'

pos = (a) -> Math.abs a
neg = (a) -> - Math.abs(a)

module.exports = spec '{} flow' (it, spec) ->

  spec 'either()' ->
    it 'either(p, f, g)(a) = if p(a) then f(a) else g(a).' do
      for-all(Bool, Int) .satisfy (a, b) ->
        either((-> a), pos, neg)(b) == (if a => pos(b) else neg(b))
      .as-test!

  spec 'unless()' ->
    it 'unless(p, f)(a) = if not p(a) then f(a).' do
      for-all(Bool, Int) .satisfy (a, b) ->
        _unless((-> a), pos)(b) == (unless a => pos(b))
      .as-test!
  
  spec 'limit()' ->
    it 'Should return the value if invocations < limit.' ->
      p = limit 2, pos
      xs = [p(1), p(2), p(3)]

      expect xs .to.deep.equal [1, 2, void]

  spec 'once()' ->
    it 'Should return the value only in the first invocation.' ->
      p = once pos
      xs = [p(1), p(2)]

      expect xs .to.deep.equal [1, void]

  spec 'until()' ->
    it 'Should only yield values before the predicate holds.' ->
      p = _until (> 2), pos
      xs = [p(1), p(2), p(3), p(0)]

      expect xs .to.deep.equal [1, 2, void, void]

  spec 'when()' ->
    it 'Should only yield values after the predicate holds.' ->
      p = _when (> 2), pos
      xs = [p(1), p(2), p(3), p(0)]
      
      expect xs .to.deep.equal [void, void, 3, 0]
