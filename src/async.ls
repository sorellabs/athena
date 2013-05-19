# # Module async
#
# Asynchronous function calls
#
# :licence: MIT
#   Copyright (c) 2013 Quildreen "Sorella" Motta <quildreen@gmail.com>
#   
#   Permission is hereby granted, free of charge, to any person
#   obtaining a copy of this software and associated documentation files
#   (the "Software"), to deal in the Software without restriction,
#   including without limitation the rights to use, copy, modify, merge,
#   publish, distribute, sublicense, and/or sell copies of the Software,
#   and to permit persons to whom the Software is furnished to do so,
#   subject to the following conditions:
#   
#   The above copyright notice and this permission notice shall be
#   included in all copies or substantial portions of the Software.
#   
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
#   BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
#   ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
#   CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#   SOFTWARE.


# -- Dependencies ------------------------------------------------------
{curry} = require './higher-order'



# -- Constants ---------------------------------------------------------
set-immediate-p    = 'setImmediate' of this
node-p             = 'process' of this
deferred-timeout-p = 'postMessage' of this



# -- Helpers -----------------------------------------------------------
deferred-timeout = when deferred-timeout-p => do ->
  timeouts = []
  message  = '*athena-deferred-application*'

  window.add-event-listener 'message', handle-message, true

  function handle-message(event)
    if (event.source is window and event.data is message)
      event.stop-propagation!
      fun = timeouts.shift!
      if fun => fun!

  (fun) -> do
           timeouts.push fun
           window.post-message message, '*'



# -- Core implementation -----------------------------------------------

# ### Function delay
#
# Executes the given function after (at least) the given seconds.
#
# :: number -> (A... -> B) -> timer-id
delay = (seconds, f) -> set-timeout f, seconds * 1_000


# ### Function defer
#
# Asynchronously executes the function as soon as possible.
#
# This should be on the next event tick for Node.js and browsers that
# support the `postMessage` protocol. Otherwise, it'll rely on the
# `setTimeout` application, which can be kind-of *slow*.
#
# :: (A... -> B) -> ()
defer = (f) ->
  | set-immediate-p    => set-immediate f
  | node-p             => process.next-tick f
  | deferred-timeout-p => deferred-timeout f
  | otherwise          => delay 0, f


# -- Exports -----------------------------------------------------------
module.exports = {
  delay: curry delay
  defer
}
