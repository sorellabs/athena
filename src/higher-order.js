/// higher-order.js --- Higher order / function wrapping utilities
//
// Copyright (c) 2012 The Orphoundation
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation files
// (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge,
// publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/// Module athena.higher-order

//// -- Aliases ----------------------------------------------------------------
var slice = [].slice



//// -- Composition ------------------------------------------------------------

///// Function compose /////////////////////////////////////////////////////////
//
// Yields a new function that applies each function in the chain in
// reverse order, passing the result of the previous computation over.
//
// compose :: (Any... -> Any)... -> Any
function compose() {
  var funs = slice.call(arguments)
  var len  = funs.length

  return function _Composition() {
           var result = arguments
           var i      = len
           while (i--)
             result = [funs[i].apply(this, result)]

           return result[0] }}



//// -- Currying & Partials ----------------------------------------------------

///// Function curry ///////////////////////////////////////////////////////////
//
// Creates a curried function, which returns the original function until
// all arguments have been gathered.
//
// For functions with variadic arity, it's possible to specify which
// arity should be considered for the curried function. If none is
// specified, we rely on the ``Function#length`` property for this.
//
// curry :: Number?, (a... -> b), [a]? -> a... -> ... -> b
function curry(arity, fun, initial) {
  if (typeof arity == 'function') {
    initial = arguments[1]
    fun     = arity
    arity   = fun.length }

  return function _Curried() {
           var args = (initial || []).concat(slice.call(arguments))

           return args.length < arity?  curry(arity, fun, args)
           :      /* otherwise */       fun.apply(this, args) }}


///// Function uncurry /////////////////////////////////////////////////////////
//
// Creates a function that takes a list of arguments, then applies those
// arguments to the original function.
//
// uncurry :: (a... -> b) -> [a] -> b
function uncurry(fun) {
  return function _Uncurried(args) {
           return fun.apply(this, args) }}


///// Function uncurryBind /////////////////////////////////////////////////////
//
// Creates a function that takes a list of arguments, the first being
// the object the function should be applied to (``this``), the rest
// being the arguments to be passed to the function, then applies those
// arguments to the original function.
//
// uncurryBind :: (a... -> b) -> [this, a...] -> b
function uncurryBind(fun) {
  return function _UncurriedBound(args) {
           fun.call.apply(fun, args) }}


///// Function partial /////////////////////////////////////////////////////////
//
// Partially applies the given arguments to the function, returning a
// new function.
//
// partial :: (a... -> b), a... -> a... -> b
function partial(fun) {
  var args = slice.call(arguments, 1)

  return function _PartiallyApplied() {
           var all_args = args.concat(slice.call(arguments))
           return fun.apply(this, all_args) }}



//// -- Wrapping & Advice ------------------------------------------------------

///// Function wrap ////////////////////////////////////////////////////////////
//
// Returns a function that wraps the invocation of the given function.
//
// wrap :: Fun, (Fun -> a) -> b
function wrap(fun, wrapper) {
  return function _Wrapper() {
           return wrapper.apply(this, [fun].concat(slice.call(arguments))) }}



//// -- Exports ----------------------------------------------------------------
module.exports = { compose: compose
                 , curry: curry
                 , uncurry: uncurry
                 , uncurryBind: uncurryBind
                 , partial: partial
                 , wrap: wrap }