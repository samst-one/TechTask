// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RoundUp",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RoundUp",
            targets: ["RoundUp"]),
    ],
    dependencies: [
        .package(path: "UI"),
        .package(path: "Networking"),
        .package(path: "Auth"),
        .package(path: "Currency"),

    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RoundUp",
            dependencies: ["UI", "Networking", "Auth", "Currency"]),
        .testTarget(
            name: "RoundUpTests",
            dependencies: ["RoundUp"]),
    ]
)
