(function(){
  var curry, setImmediateP, nodeP, deferredTimeoutP, deferredTimeout, delay, defer;
  curry = require('./higher-order').curry;
  setImmediateP = 'setImmediate' in this;
  nodeP = 'process' in this;
  deferredTimeoutP = 'postMessage' in this;
  deferredTimeout = (function(){
    switch (false) {
    case !deferredTimeoutP:
      return function(){
        var timeouts, message;
        timeouts = [];
        message = '*athena-deferred-application*';
        window.addEventListener('message', handleMessage, true);
        function handleMessage(event){
          var fun;
          if (event.source === window && event.data === message) {
            event.stopPropagation();
            fun = timeouts.shift();
            if (fun) {
              return fun();
            }
          }
        }
        return function(fun){
          timeouts.push(fun);
          return window.postMessage(message, '*');
        };
      }();
    }
  }());
  delay = function(seconds, f){
    return setTimeout(f, seconds * 1000);
  };
  defer = function(f){
    switch (false) {
    case !setImmediateP:
      return setImmediate(f);
    case !nodeP:
      return process.nextTick(f);
    case !deferredTimeoutP:
      return deferredTimeout(f);
    default:
      return delay(0, f);
    }
  };
  module.exports = {
    delay: curry(delay),
    defer: defer
  };
}).call(this);
