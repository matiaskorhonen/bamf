// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "ISOBMFF",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "ISOBMFF",
      targets: ["ISOBMFF"])

  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-testing.git", branch: "main")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "ISOBMFF"),
    .testTarget(
      name: "ISOBMFFTests",
      dependencies: [
        "ISOBMFF",
        .product(name: "Testing", package: "swift-testing"),
      ],
      resources: [
        .copy("Resources")
      ]),
  ]
)
