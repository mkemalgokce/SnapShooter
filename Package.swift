// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SnapShooter",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SnapShooter",
            targets: ["SnapShooter"]),
    ],
    targets: [
        .target(
            name: "SnapShooter"),
        .testTarget(
            name: "SnapShooterTests",
            dependencies: ["SnapShooter"]
        ),
    ]
)
