brofist  = require 'brofist'
reporter = require 'brofist-tap'

brofist.run (require './specs'), reporter!
