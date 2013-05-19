(function(){
  var brofist, reporter;
  brofist = require('brofist');
  reporter = require('brofist-tap');
  brofist.run(require('./specs'), reporter());
}).call(this);
