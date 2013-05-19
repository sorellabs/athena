(function(){
  var brofist, reporter;
  brofist = require('brofist');
  reporter = require('brofist-minimal');
  brofist.run(require('./specs'), reporter()).then(function(it){
    if (it.failed.length) {
      return process.exit(1);
    }
  });
}).call(this);
