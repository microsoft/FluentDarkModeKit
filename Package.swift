// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "DarkModeKit",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "DarkModeKit", targets: [
            "DarkModeCore",
            "DarkModeKit",
        ])
    ],
    targets: [
        .target(name: "DarkModeCore"),
        .target(name: "DarkModeKit", dependencies: ["DarkModeCore"]),
        .testTarget(name: "DarkModeKitTests", dependencies: ["DarkModeKit"]),
    ]
)
