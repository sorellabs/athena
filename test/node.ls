brofist  = require 'brofist'
reporter = require 'brofist-minimal'

(brofist.run (require './specs'), reporter!).then ->
  if it.failed.length => process.exit 1
