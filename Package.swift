// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Bamf!",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v13),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Bamf",
      targets: ["Bamf"]),
    .executable(name: "bamf-cli", targets: ["BamfCLI"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    .package(url: "https://github.com/csjones/lefthook-plugin.git", exact: "2.1.1"),
  ],
  targets: [
    .target(
      name: "Bamf"),
    .executableTarget(
      name: "BamfCLI",
      dependencies: [
        "Bamf",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]
    ),
    .testTarget(
      name: "BamfTests",
      dependencies: [
        "Bamf"
      ],
      resources: [
        .copy("Fixtures")
      ]),
    .testTarget(
      name: "BamfCLITests",
      dependencies: [
        "BamfCLI"
      ]),
  ]
)
