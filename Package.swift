// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Framing",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(
            name: "Framing",
            targets: ["Framing"]
        ),
        .library(
            name: "Framer",
            targets: ["Framer"]
        ),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Framing",
            dependencies: []
        ),
        .testTarget(
            name: "FramingTests",
            dependencies: ["Framing"]
        ),
        .target(
            name: "Framer",
            dependencies: ["Framing"]
        ),
        .testTarget(
            name: "FramerTests",
            dependencies: ["Framer", "Framing"]
        ),
    ]
)
