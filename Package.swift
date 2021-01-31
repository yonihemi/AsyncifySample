// swift-tools-version:5.3
import PackageDescription
let package = Package(
    name: "AsyncifySample",
    products: [
        .executable(name: "AsyncifySample", targets: ["AsyncifySample"])
    ],
    dependencies: [
        .package(name: "JavaScriptKit", url: "https://github.com/yonihemi/JavaScriptKit", 
            .branch("asyncify-npm")),
    ],
    targets: [
        .target(
            name: "AsyncifySample",
            dependencies: [
                .product(name: "JavaScriptKit", package: "JavaScriptKit"),
            ]),
    ]
)