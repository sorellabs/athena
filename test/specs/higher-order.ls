spec                   = (require 'brofist')!
{for-all, sized, data} = require 'claire'
{Int}                  = data

{ compose                               \
, curry, partial, uncurry, uncurry-bind \
, flip                                  \
, wrap                                  } = require '../../lib/higher-order'

{ id } = require '../../lib/core'

x = (t) -> t.disable()

module.exports = spec '{} higher-order' (it, spec) ->

  spec 'compose()' ->
    f = (+ 1)
    g = (- 2)
    h = (* 3)

    it 'Given `f: a → b` and `g: b → c`, then `(g . f): a → c`' do
      for-all (Int) .satisfy (a) ->
        compose(g, f)(a) == g(f(a))
      .as-test!

    it 'associativity: `f . (g . h)` = `(f . g) . h`' do
      for-all (Int) .satisfy (a) ->
        compose(f, compose(g, h))(a) == compose(compose(f, g), h)(a)
      .as-test!

    it 'left identity: `id . f` = f`' do
      for-all (Int) .satisfy (a) ->
        compose(id, f)(a) == f(a)
      .as-test!

    it 'right identity: `f . id` = f`' do
      for-all (Int) .satisfy (a) ->
        compose(f, id)(a) == f(a)
      .as-test!


  spec 'curry()' ->
    add = (a, b)  -> a + b
    sum = (...as) -> as.reduce (+), 0

    it 'Given `f: (a, b) → c`, a curried form should be `f: a → b → c`' do
      for-all(Int, Int) .satisfy (a, b) ->
        add(a, b) == curry(add)(a)(b)
      .as-test!

    it 'Should allow specifying arity for variadic functions.' do
      for-all(Int, Int, Int) .satisfy (a, b, c) ->
        curry(3, sum)(a)(b)(c) == sum(a, b, c)
      .as-test!

    it 'Should allow more than one argument applied at a time.' do
      for-all(Int, Int, Int) .satisfy (a, b, c) ->
        curry(3, sum)(a, b)(c) == curry(3, sum)(a)(b, c) == sum(a, b, c)
      .as-test!

    it 'Should accept initial arguments as an array.' do
      for-all(Int, Int, Int) .satisfy (a, b, c) ->
        curry(3, sum, [a])(b)(c) == sum(a, b, c)
      .as-test!


  spec 'partial()' ->
    add = (a, b, c) -> a + b + (c or 0)

    it 'For a function `f: (a..., b...) → c`, should yield `f: (b...) → c`' ->
      for-all(Int, Int) .satisfy (a, b) ->
        partial(add, 1)(2) == add(1, 2, 0)
      .as-test!


  spec 'uncurry()' ->
    sum = (...as) -> as.reduce (+), 0
    
    it 'Should convert an `f: (a... -> b)` into `f: [a] -> b`' ->
      for-all(Int, Int, Int) .satisfy (a, b, c) ->
        uncurry(sum)([a, b, c]) == sum(a, b, c)
      .as-test!

  
  spec 'uncurry-bind()' ->
    sum  = (...as) -> as.reduce (+), @head
    usum = uncurry-bind sum

    it 'Should convert an `f: (a... -> b)` into `f: [this, a...] -> b`' do
      for-all(Int, Int) .satisfy (a, b) ->
        usum([{ head: 1 }, 2, 3]) == sum.call({ head: 1 }, 2, 3)
      .as-test!


  spec 'flip()' ->
    x it 'Should return a function of the same length.'
    x it 'flip(f)(b)(a) = f(a, b).'
    x it 'flip(flip(f)(b))(a) = flip(a, b).'


  spec 'wrap()' ->
    add   = (+)
    plus1 = (f, a) -> f(a, 1)
    
    it 'Should pass the wrapped function as first argument.' do
      for-all(Int) .satisfy (a) ->
        wrap(plus1, add)(a) == add(a, 1)
      .as-test!

