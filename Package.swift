// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ShaderKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "ShaderKit",
            targets: ["ShaderKit"]
        ),
    ],
    targets: [
        .target(
            name: "ShaderKit",
            resources: [
                .process("Shaders")
            ]
        ),
        .testTarget(
            name: "ShaderKitTests",
            dependencies: ["ShaderKit"]
        ),
    ]
)
