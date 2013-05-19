# # Module higher-order
#
# Higher order / function wrapping utilities
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


# -- Composition -------------------------------------------------------

# ### Function comopose
#
# Composes several functions together.
#
# Yields a new function that composes the given functions together. That
# is, each function in the chain is called with the return value from
# the previous function in the chain, in reverse order.
#
# :: (A... -> B)... -> A... -> B
compose = ->
  fs  = arguments
  len = fs.length

  -> do
     result = arguments
     i      = len

     while (i--) => result = [fs[i].apply this, result]

     return result.0



# -- Currying & Partials -----------------------------------------------

# ### Function curry
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
# :: number?, (A... -> B), [A]? -> A... -> (A... -> B) | B
curry = (arity, f, initial) ->
  if (typeof arity is 'function')
    initial = arguments[1]
    f       = arity
    arity   = f.length


  (...args) -> do
               args := (initial or []) ++ args

               if args.length < arity => curry arity, f, args
               else                   => f.apply this, args


# ### Function partial
#
# Partially applies the given arguments to the function.
#
# :: (A... -> B), A... -> A... -> B
partial = (f, ...args) -> (...additional-args) ->
  f.apply this, (args ++ additional-args)


# ### Function uncurry
#
# Transforms a curried funtion to a function on lists.
#
# :: (A... -> B) -> [A] -> B
uncurry = (f) -> (args) -> f.apply this, args


# ### Function uncurry-bind
#
# Transforms a curried function to a function on lists, with binding
# context.
#
# Yields a function that takes a list of arguments, the first being the
# object that the function should be applied to (`this`), the rest
# being the actual arguments to be passed to the function, the returns
# the result of applying the original function to such arguments.
#
# :: (A... -> B) -> [this, A...] -> B
uncurry-bind = (f) -> (args) -> f.call.apply f, args


# ### Function flip
#
# Inverts the order in which parameters are applied for a binary function.
#
# :: (A, B -> C) -> B -> A -> C
flip = (f) -> ...



# -- Wrapping & Advice -------------------------------------------------

# ### Function wrap
#
# Returns a function that wraps the invocation of the given function.
#
# :: (f, C... -> D) -> f:(A... -> B) -> C... -> D
wrap = (wrapper, f) -> (...args) ->
  wrapper.apply this, ([f] ++ args)



# -- Exports -----------------------------------------------------------
module.exports = {
  # Composition
  compose

  # Currying / Partial application
  curry
  partial
  uncurry
  uncurry-bind
  flip

  # Wrapping / Advice
  wrap: curry wrap
}
