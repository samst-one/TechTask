// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AddSavingsGoal",
    platforms: [
        .iOS(.v16),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AddSavingsGoal",
            targets: ["AddSavingsGoal"]),
    ],
    dependencies: [
        .package(path: "Currency"),
        .package(path: "UI"),
        .package(path: "Networking"),
        .package(path: "Auth")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AddSavingsGoal",
            dependencies: ["UI", "Networking", "Auth", "Currency"]),
        .testTarget(
            name: "AddSavingsGoalTests",
            dependencies: ["AddSavingsGoal"]),
    ]
)
