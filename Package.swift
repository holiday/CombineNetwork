// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CombineNetwork",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CombineNetwork",
            targets: ["CombineNetwork"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CombineNetwork",
            dependencies: []),
        .testTarget(
            name: "CombineNetworkTests",
            dependencies: ["CombineNetwork"]),
    ]
)
