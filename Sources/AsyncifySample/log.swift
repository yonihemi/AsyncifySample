import JavaScriptKit

fileprivate class Logger {
    let divElement: JSObject

    static let shared = Logger()

    init() {
        let document = JSObject.global.document.object!
        self.divElement = document.createElement!("div").object!
        divElement.style.object!["font-family"] = "ui-monospace, monospace"
        divElement.innerText = ""
        let body = document.body.object!
        _ = body.appendChild!(divElement)
    }

    func log(_ text: String) {
        let existing = divElement.innerText.string!
        divElement.innerText = JSValue(stringLiteral: existing + text + "\n")
        _ = JSObject.global.console.log(text)
    }
}

func log(_ text: String) {
    Logger.shared.log(text)
}