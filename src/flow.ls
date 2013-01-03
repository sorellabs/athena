### flow.ls --- Lifted flow control routines
#
# Copyright (c) 2012-2013 The Orphoundation
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


### Module athena.flow


#### -- Dependencies ---------------------------------------------------
{curry} = require './higher-order'



#### -- Core implementation --------------------------------------------

#### Function either
#
# Executes one or the other function based on the predicate.
#
# either :: Pred -> Fun -> Fun -> a... -> b
either = (pred, consequent, alternate) -> ->
  | pred ...  => consequent ...
  | otherwise => alternate ...


#### Function unless
#
# Executes the function unless the predicate holds.
#
# unless :: Pred -> Fun -> a... -> b
Unless = (pred, consequent) -> unless pred ... => consequent ...


#### Function limit
#
# Yields a function that may only be called X times
#
# limit :: Number -> Fun -> Fun
limit = (times, fun) -> -> if --times < 0 => fun ...


#### Function once
#
# Yields a function that may only be called once
#
# once :: Fun -> Fun
once = limit 1


#### Function until
#
# Yields a function that will only be called until the predicate holds.
#
# until :: Pred -> Fun -> Fun
Until = (pred, fun) ->
  call = true

  -> if call and (call := not pred ...) => fun ...


#### Function when
#
# Yields a function that will only be called after the predicate holds.
#
# when :: Pred -> Fun -> Fun
When = (pred, fun) ->
  call = false

  -> | call     => fun ...
     | pred ... => do
                   call := true
                   fun ...



#### -- Exports --------------------------------------------------------
module.exports = {
  either
  unless: curry Unless
  limit
  once
  until: curry Until
  when: curry When
}