// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Bamf!",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "Bamf",
      targets: ["Bamf"]),
    .executable(name: "bamf-cli", targets: ["BamfCLI"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
    .package(url: "https://github.com/apple/swift-testing.git", branch: "main"),
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
        "Bamf",
        .product(name: "Testing", package: "swift-testing"),
      ],
      resources: [
        .copy("Resources")
      ]),
  ]
)
