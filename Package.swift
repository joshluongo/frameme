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
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .executableTarget(name: "frameme", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]),
        .testTarget(
            name: "framemeTests",
            dependencies: ["frameme"],
            resources: [
              // Resources for tests.
              .copy("Resources")
            ]
        )
    ]
)
