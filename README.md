# SwiftWasm Asyncify Sample

Showcase SwiftWasm code that's impossible to accomplish without Asyncify method:
- **Sleep**ing inside synchronous code, without resorting to callback (or Swift Next's async/await).
- An initializer (which needs to return synchronously) that depends on asynchronous code from the outside world.

# Prerequisites
- Install the [SwiftWasm toolchain](https://book.swiftwasm.org/getting-started/setup.html)
- Set SwiftWasm's `swift` as default or edit the swift command in `build.sh`.
- Install the [Binaryen toolchain](https://github.com/WebAssembly/binaryen) (we'll use the `wasm-opt` tool from there).
- Set Binaryen's `/bin` in PATH or edit the wasm-opt command in `build.sh`.

# Building Javascript
``` sh
npm install
npm run build
```

# Building Swift
``` sh
./build.sh
```
Output files are written to /dist folder.