// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "MP4File",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "MP4File",
      targets: ["MP4File"])

  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-testing.git", branch: "main")
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "MP4File"),
    .testTarget(
      name: "MP4FileTests",
      dependencies: [
        "MP4File",
        .product(name: "Testing", package: "swift-testing"),
      ],
      resources: [
        .copy("Resources")
      ]),
  ]
)
