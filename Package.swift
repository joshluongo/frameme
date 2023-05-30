// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "frameme",
    platforms: [
        // Only macOS because of the difference in CoreGraphics between macOS and iOS.
        //
        // This would be trivial to modify so it worked on iOS platforms.
        .macOS(.v10_15)
    ],
    products: [
        .library(name: "FrameKit", targets: ["FrameKit"]),
        .executable(name: "frameme", targets: ["FrameMe-Cli"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.2")
    ],
    targets: [
        .target(name: "FrameKit"),
        .executableTarget(name: "FrameMe-Cli", dependencies: [
            "FrameKit",
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]),
        .testTarget(
            name: "FrameKitTests",
            dependencies: ["FrameKit"],
            resources: [
              // Resources for tests.
              .copy("Resources")
            ]
        )
    ]
)
