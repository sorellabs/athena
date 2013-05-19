spec = (require 'brofist')!
{expect}:chai = require 'chai'
chai.use (require 'chai-as-promised')
pinky = require 'pinky'

{ delay, defer } = require '../../lib/async'

module.exports = spec '{} async' (it, spec) ->

  spec 'delay()' ->
    it 'Should execute the function after the given seconds.' ->
      promise = pinky!
      start   = new Date
      delay 1, -> promise.fulfill ((new Date - start) / 1000)

      expect promise .to.eventually.be.at.least 1

  spec 'defer()' ->
    it 'Should execute in the next loop/end of this loop.' ->
      promise = pinky!
      as      = []
      defer -> promise.fulfill as
      as.push 1

      expect promise .to.become [1]
