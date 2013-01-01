### higher-order.ls --- Higher order / function wrapping utilities
#
# Copyright (c) 2012 The Orphoundation
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

### Module athena.higher-order



#### -- Composition ----------------------------------------------------

##### Function comopose
#
# Composes several functions together.
#
# Yields a new function that composes the given functions together. That
# is, each function in the chain is called with the return value from
# the previous function in the chain, in reverse order.
#
# compose :: Fun... -> Fun
compose = ->
  funs = arguments
  len  = funs.length


  -> do
     result = arguments
     i      = len

     while (i--) => result = [funs[i].apply this, result]

     return result.0



#### -- Currying & Partials --------------------------------------------

##### Function curry
#
# Creates a curried function from an uncurried one.
#
# A curried function is one that will return itself until all the
# arguments required to apply the function are gathered, at which point
# the original function is called with the gathered arguments.
#
# For functions with variadic arity, it's possible to specify which
# arity should be considered for the curried function. If none is
# specified, we rely on the ``Function.prototype.length`` property for
# this.
#
# curry :: Number?, (a... -> b), [a]? -> a... -> ... -> b
curry = (arity, fun, initial) ->
  if (typeof arity is 'function')
    initial = arguments[1]
    fun     = arity
    arity   = fun.length


  (...args) -> do
               args := (initial or []) ++ args

               if args.length < arity => curry arity, fun, args
               else                   => fun.apply this, args


##### Function partial
#
# Partially applies the given arguments to the function.
#
# partial :: (a... -> b), a... -> a... -> b
partial = (fun, ...args) -> (...additional-args) ->
  fun.apply this, (args ++ additional-args)


##### Function uncurry
#
# Transforms a curried funtion to a function on lists.
#
# uncurry :: (a... -> b) -> [a] -> b
uncurry = (fun) -> (args) -> fun.apply this, args


##### Function uncurry-bind
#
# Transforms a curried function to a function on lists, with binding
# context.
#
# Yields a function that takes a list of arguments, the first being the
# object that the function should be applied to (``this``), the rest
# being the actual arguments to be passed to the function, the returns
# the result of applying the original function to such arguments.
#
# uncurry-bind :: (a... -> b) -> [this, a...] -> b
uncurry-bind = (fun) -> (args) -> fun.call.apply this, args


##### Function flip
#
# Inverts the order in which parameters are applied.
#
# flip :: Fun -> a... -> b
flip = (fun) -> (...args) ->
  fun.apply this, args.reverse!



#### -- Wrapping & Advice ----------------------------------------------

##### Function wrap
#
# Returns a function that wraps the invocation of the given function.
#
# wrap :: f:Fun, (f, a... -> b) -> b
wrap = (wrapper, fun) -> (...args) ->
  wrapper.apply this, ([fun] ++ args)



#### -- Exports --------------------------------------------------------
module.exports = {
  # -- Composition
  compose

  # -- Currying / Partial application
  curry
  partial
  uncurry
  uncurry-bind
  flip

  # -- Wrapping / Advice
  wrap: curry wrap
}