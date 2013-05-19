# Athena [![Build Status](https://travis-ci.org/killdream/athena.png)](https://travis-ci.org/killdream/athena) ![Dependencies Status](https://david-dm.org/killdream/athena.png)


Athena is a library that provides core functional combinators like `Curry`,
`Compose`, `Partial`, etc. Combinators range from lambda calculus, to general
higher-order functions, to logic and control-flow combinators.


## Example

```js
var _ = require('athena')

function add2(a, b) { return a + b }

var add = _.curry(add2)

_.compose( _.add(1)
         , _.uncurry(add2)
         , _.k([2, 3])
         )()
// => 6
```


## Installing

The easiest way is to grab it from NPM (use [browserify][] if you're on a
Browser):

    $ npm install athena
    
If you **really** want to continue suffering with old and terrible module
systems (or use no module system at all), you can run `make dist` yourself:

    $ git clone git://github.com/killdream/athena
    $ cd athena
    $ npm install
    $ make dist
    # Then use `dist/athena.umd.js` wherever you want.
    
[browserify]: https://github.com/substack/node-browserify
    

## Platform support

This library assumes an ES5 environment, but can be easily supported in ES3
platforms by the use of shims. Just include [es5-shim][] :3

[es5-shim]: https://github.com/kriskowal/es5-shim

[![browser support](https://ci.testling.com/killdream/athena.png)](http://ci.testling.com/killdream/athena)


## Tests

    $ npm test
    
    
## API

### `noop()`

Does nothing.

```hs
noop: () -> ()
```
```js
noop(1) // => undefined
```


### `k(a)`

The constant function in lambda calculus.

```hs
k: A -> () -> A
```
```js
k(1)(2) // => 1
```

### `id(a)`

The identity function in lambda calculus.

```hs
id: A -> A
```
```js
id(1) // => 1
```

### `delay(seconds, f)`

Executes the given function after (at least) the given seconds.

```hs
delay: number -> (A... -> B) -> timer-id
```
```js
delay(0.5, function(){ console.log(2) })
console.log(1)
// 1
// 2
```

### `defer(f)`

Executes the function asynchronously, as soon as possible.

```hs
defer: (A... -> B) -> ()
```
```js
defer(function(){ console.log(2) })
console.log(1)
// 1
// 2
```

### `compose(...)`

Function composition (`compose(f, g)(x)` = `f(g(x))`).

```hs
compose: (A... -> B)... -> A... -> B
```
```js
function double(x){ return x + x }
function squared(x){ return x * x }

var doubleSquared = compose(squared, double)
doubleSquared(2) // => 16
```

### `curry(arity, f, ...)`

Creates a curried function from an uncurried one.

```hs
curry: number?, (A... -> B), [A]? -> A... -> (A... -> B) | B
```
```js
function add(a, b){ return a + b }
var curriedAdd = curry(add)

var add1 = curriedAdd(1)
add1(2) // => 3
```

### `partial(f, ...)`

Partially applies the given arguments to a function.

```hs
partial: (A... -> B), A... -> A... -> B
```
```js
function add(a, b){ return a + b }
var add1 = partial(add, 1)
add1(2) // => 3
```

### `uncurry(f)`

Transforms a curried function to a function on lists.

```hs
uncurry: (A... -> B) -> [A] -> B
```
```js
var toArray = Function.call.bind([].slice)
function add(a, b){ return a + b }
function sum(){ return toArray(arguments).reduce(add, 0) }

sum([1, 2, 3]) // => 6
```

### `uncurryBind(f)`

Transforms a curried function to a function on lists, where the first item of
the list is the value of `this`.

```hs
uncurryBind: (A... -> B) -> [this, A...] -> B
```
```js
var bag = {
  items: [],
  add: function() {
    this.items.push.apply(this.items, arguments)
  }
}

var addToBag = uncurryBind(bag.add)
var otherBag = { __proto__: bag, items: [] }

addToBag([otherBag, 1, 2])

otherBag.items // => [1, 2]
```

### `wrap(advice, f)`

Wraps the invocation of `f` in the given `advice`. The `advice` can then decide
what to do with the function.

```hs
f: (A... -> B)
wrap: (f, C... -> D) -> f -> C... -> D
```
```js
function add(a, b) { return a + b }
function trace(f, a, b) {
  console.log('Calling %s with: %s, %s', f.name, a, b)
  var result = f(a, b)
  console.log('Returned: %s', result)
  return result
}

var tracedAdd = wrap(trace, add)

tracedAdd(1, 2)
// Calling add with: 1, 2
// Returned: 3
// => 3
```

### `either(predicate, consequent, alternate, ...)`

`either(p, f, g)(a)` is the same as `p(a)? f(a) : g(a)`.

```hs
either: (A... -> bool) -> (A... -> B) -> (A... -> C) -> A... -> B | C
```
```js
function isNegative(a) { return a < 0 }
function negate(a) { return -a }
var abs = either(isNegative, negate, id)

abs(-2) // => 2
abs(2) // => 2
```

### `unless(predicate, consequent, ...)`

`unless(p, f)(a)` is the same as `if (!p(a))  f(a)`.

This is also aliased as `_unless` for LiveScript/CoffeeScript.

```hs
unless: (A... -> bool) -> (A... -> B) -> A... -> maybe B
```
```js
function isCallable(a){ return typeof a == 'function' }
function raise(e){ throw new Error(e) }
function unwrap(f){ return f() }

unless(isCallable, unwrap)(function(){ return 1 }) // => 1
```

### `limit(n, f)`

Yields a function that will apply `f` the first `N` times.

```hs
limit: number -> (A... -> B) -> (A... -> maybe B)
```
```js
var f = limit(2, id)
[f(1), f(2), f(3)] // => [1, 2, undefined]
```

### `once(f)`

Yields a function that will apply `f` only once.

```hs
once: (A... -> B) -> (A... -> maybe B)
```
```js
var f = once(id)
[f(1), f(2)] // => [1, undefined]
```

### `until(predicate, f)`

Yields a function that will only apply `f` before the predicate holds.

This is also aliased as `_until` for LiveScript/CoffeeScript.

```hs
until: (A... -> bool) -> (A... -> B) -> (A... -> maybe B)
```
```js
function greaterThan(a, b){ return a > b }
function sub(a, b){ return a - b }

var subGreater = until(greaterThan, sub)

subGreater(1, 2) //=> undefined
subGreater(2, 2) //=> undefined
subGreater(3, 2) //=> 1
subGreater(0, 2) //=> -2
```

### `when(predicate, f)`

Yields a function that will only apply `f` after the predicate holds.

This is also aliased as `_when` for LiveScript/CoffeeScript.

```hs
when: (A... -> bool) -> (A... -> B) -> (A... -> maybe B)
```
```js
function greaterThan(a, b){ return a > b }
function sub(a, b){ return a - b }

var subGreater = when(greaterThan, sub)

subGreater(1, 2) //=> -1
subGreater(2, 2) //=> 0
subGreater(3, 2) //=> undefined
subGreater(0, 2) //=> undefined
```

### `or(...)`

Yields a function that will apply each function in turn, and return the value
of the first truthy one.

This is also aliased as `_or` for LiveScript/CoffeeScript.

```hs
or: (A... -> B)... -> A... -> maybe B
```


### `and(...)`

Yields a function that will apply each function in turn, and return the value
of the last truthy one.

This is aliased as `_and` for LiveScript/CoffeeScript.

```hs
and: (A... -> B)... -> A... -> maybe B
```

### `not(f)`

Yields a function that will return the negated result of applying `f`.

```hs
not: (A... -> bool) -> A... -> bool
```


## Licence

MIT/X11. ie.: do whatever you want.


