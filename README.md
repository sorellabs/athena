# Athena [![Build Status](https://travis-ci.org/killdream/athena.png)](https://travis-ci.org/killdream/athena)


Athena is a library that provides core functional combinators like `Curry`,
`Compose`, `Partial`, etc. Combinators range from lambda calculus, to general
higher-order functions, to logic and control-flow combinators.


### Platform support

This library assumes an ES5 environment, but can be easily supported in ES3
platforms by the use of shims. Just include [es5-shim][] :3

[![browser support](https://ci.testling.com/killdream/athena.png)](http://ci.testling.com/killdream/athena)


### Example

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


### Installing

Just grab it from NPM:

    $ npm install athena
    
    
### Tests

You can run all tests using Mocha:

    $ npm test
    
    
### Licence

MIT/X11. ie.: do whatever you want.

[es5-shim]: https://github.com/kriskowal/es5-shim

