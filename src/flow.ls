# # Module flow
#
# Lifted flow control routines
#
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



# -- Core implementation -----------------------------------------------

# ### Function either
#
# Executes one or the other function based on the predicate.
#
# :: (A... -> bool) -> (A... -> B) -> (A... -> C) -> A... -> B | C
either = curry 4, (pred, consequent, alternate, ...xs) ->
  | pred.call this, xs => consequent.call this, xs
  | otherwise          => alternate.call this, xs


# ### Function unless
#
# Executes the function unless the predicate holds.
#
# :: (A... -> bool) -> (A... -> B) -> A... -> maybe B
Unless = curry 3, (pred, consequent, ...xs) ->
  unless pred.call this, xs => consequent.call this, xs


# ### Function limit
#
# Yields a function that may only be called X times
#
# :: number -> (A... -> B) -> (A... -> maybe B)
limit = curry (times, f) -> -> if --times >= 0 => f ...


# ### Function once
#
# Yields a function that may only be called once
#
# :: (A... -> B) -> (A... -> maybe B)
once = limit 1


# ### Function until
#
# Yields a function that will only be called until the predicate holds.
#
# :: (A... -> bool) -> (A... -> B) -> (A... -> maybe B)
Until = curry (pred, f) ->
  call = true

  -> if call and (call := not pred ...) => f ...


# ### Function when
#
# Yields a function that will only be called after the predicate holds.
#
# :: (A... -> bool) -> (A... -> B) -> (A... -> maybe B)
When = curry (pred, f) ->
  call = false

  -> | call     => f ...
     | pred ... => do
                   call := true
                   f ...



# -- Exports -----------------------------------------------------------
module.exports = {
  either
  unless  : Unless
  _unless : Unless
  limit
  once
  until  : Until
  _until : Until
  when   : When
  _when  : When
}
