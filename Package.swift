// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Framing",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "Framing", targets: ["Framing"])
    ],
    dependencies: [],
    targets: [
        .target(name: "Framing", dependencies: []),
        .testTarget(name: "FramingTests", dependencies: ["Framing"]),
    ]
)
