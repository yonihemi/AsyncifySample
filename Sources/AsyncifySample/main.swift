import Foundation
import JavaScriptKit

log("Sample START")
doSleep()
doAsyncInitializer(url: "./text.txt")
doAsyncInitializer(url: "./text2.txt")
doAsyncInitializer(url: "./nosuchfile.txt")         // Expected 404
doAsyncInitializer(url: "http://example.com/no")    // Expected CORS violation
log("Sample END")

/// Impossible without `Asyncify` 1:
/// Pausing execution in a synchronous manner, without callbacks or `await`s
func doSleep() {
    for _ in 0..<3 {
        log("Going to sleep...")
        pauseExecution(milliseconds: 1000)
        log("Woke up!")
    }
}

/// Impossible without `Asyncify` 2:
/// An initializer which relies on an asyncrouncous action of the host
extension String {
    enum InitWithStringError: Error {
        /// `fetchAsText` is not available on the global object
        case incorrectHostSetup
        case notAString
    }

    init(contentsOf url: URL) throws {
        guard let fetchAsText = JSObject.global.fetchAsText.function,
              let promise = JSPromise.construct(from: fetchAsText(url.absoluteString)) else {
            throw InitWithStringError.incorrectHostSetup
        }
        let value = try promise.syncAwait().get()
        guard let string = value.string else {
            throw InitWithStringError.notAString
        } 
        self = string
    }
}

func doAsyncInitializer(url: String) {
    let url = URL(string: url)!
    do {
        let str = try String(contentsOf: url)
        log("The string is: '\(str)'")
    } catch {
        log("Failed creating string: \(error)")
    }
}
