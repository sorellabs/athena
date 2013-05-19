spec                    = (require 'brofist')!
{for-all, sized}:claire = require 'claire'
{Any}                   = claire.data

{noop, k, id} = require '../../lib/core'

Value = (sized -> 10) Any

module.exports = spec '{} core' (it, spec) ->

  spec 'noop()' ->
    it 'Should do nothing' ->
      for-all(Value) .satisfy (a) ->
        (noop a) is void
      .as-test!

  spec 'k()' ->
    it 'When applied to X should return a function' do
      for-all(Value) .satisfy (a) ->
        typeof (k a) is 'function'
      .as-test!

    it 'When applied to another argument, should return the first.' do
      for-all(Value, Value) .given (!=) .satisfy (a, b) ->
        ((k a) b) is a
      .as-test!

  spec 'id()' ->
    it 'When applied to X, should return X' do
      for-all(Value) .satisfy (a) ->
        (id a) is a
      .as-test!
