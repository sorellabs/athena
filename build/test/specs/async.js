(function(){
  var spec, chai, expect, pinky, ref$, delay, defer;
  spec = require('brofist')();
  chai = require('chai'), expect = chai.expect;
  chai.use(require('chai-as-promised'));
  pinky = require('pinky');
  ref$ = require('../../lib/async'), delay = ref$.delay, defer = ref$.defer;
  module.exports = spec('{} async', function(it, spec){
    spec('delay()', function(it){
      return it('Should execute the function after the given seconds.', function(){
        var promise, start;
        promise = pinky();
        start = new Date;
        delay(1, function(){
          return promise.fulfill((new Date - start) / 1000);
        });
        return expect(promise).to.eventually.be.at.least(1);
      });
    });
    return spec('defer()', function(it){
      return it('Should execute in the next loop/end of this loop.', function(){
        var promise, as;
        promise = pinky();
        as = [];
        defer(function(){
          return promise.fulfill(as);
        });
        as.push(1);
        return expect(promise).to.become([1]);
      });
    });
  });
}).call(this);
