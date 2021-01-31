import { SwiftRuntime } from "javascript-kit-swift";
import { WASI } from "@wasmer/wasi";
import { WasmFs } from "@wasmer/wasmfs";

const swift = new SwiftRuntime();
// Instantiate a new WASI Instance
const wasmFs = new WasmFs();

// Output stdout and stderr to console
const originalWriteSync = wasmFs.fs.writeSync;
wasmFs.fs.writeSync = (fd, buffer, offset, length, position) => {
  const text = new TextDecoder("utf-8").decode(buffer);
  if (text !== "\n") {
    switch (fd) {
      case 1:
        console.log(text);
        break;
      case 2:
        console.error(text);
        break;
    }
  }
  return originalWriteSync(fd, buffer, offset, length, position);
};

const wasi = new WASI({
  args: [],
  env: {},
  bindings: {
    ...WASI.defaultBindings,
    fs: wasmFs.fs,
  },
});


const startWasiTask = async () => {
  // Fetch our Wasm File
  const response = await fetch("./main.wasm");
  const responseArrayBuffer = await response.arrayBuffer();

  // Instantiate the WebAssembly file
  const wasmBytes = new Uint8Array(responseArrayBuffer).buffer;
  const { instance } = await WebAssembly.instantiate(wasmBytes, {
    wasi_snapshot_preview1: wasi.wasiImport,
    javascript_kit: swift.importObjects(),
    env: {
    },
  });

  const startExecution = () => {
    wasi.start(instance);
  };

  // When using asyncified modules, we need to pass in a 'restart' callback.
  swift.setInstance(instance, startExecution);

  // Start the WebAssembly WASI instance
  startExecution();

  // When using asyncified modules, we need to signal the first invocation.
  swift.didStart();
};

function handleError(e) {
  console.error(e);
  
  const overlay = document.createElement("div");
  overlay.className = "runtimeError"
  const message = document.createElement("div");
  message.className = "runtimeErrorMessage";
  overlay.appendChild(message);
  const title = document.createElement("h3");
  title.innerText = e.message || e.toString();
  message.appendChild(title);
  if (e instanceof WebAssembly.RuntimeError) {
    console.log(e.stack);
    const stack = document.createElement("div");
    stack.innerHTML = e.stack.replace("\n", "<br/>");
    message.appendChild(stack);
  }
  document.body.appendChild(overlay);
}

try {
  startWasiTask().catch(handleError);
} catch (e) {
  handleError(e);
}
