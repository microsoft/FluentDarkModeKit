// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "FluentDarkModeKit",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "FluentDarkModeKit", targets: [
            "DarkModeCore",
            "FluentDarkModeKit",
        ])
    ],
    targets: [
        .target(name: "DarkModeCore", cSettings: [.define("SWIFT_PACKAGE")]),
        .systemLibrary(name: "DarkModeCorePrivate"),
        .target(name: "FluentDarkModeKit", dependencies: ["DarkModeCore", "DarkModeCorePrivate"]),
        .testTarget(name: "FluentDarkModeKitTests", dependencies: ["FluentDarkModeKit"]),
    ]
)
