// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "MongoManager",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "MongoManager",
            targets: ["MongoManager"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-cloud/Compute", from: "1.8.0"),
    ],
    targets: [
        .target(
            name: "MongoManager",
            dependencies: ["Compute"]),
    ]
)
