# Bamf!

<p align="center">
  <img width="528" height="360" alt="Bamf! logo in the style of a comic exclamation" src="Images/BAMF.svg">
</p>

A pure Swift parser for ISOBMFF (ISO Base Media File Format) based formats such as MPEG-4 (.mp4), QuickTime movies (.mov), JPEG2000 (.jp2), and more.

> [!TIP]
> **Why is this called Bamf!?**
>
> It's my [headcanon](https://en.wiktionary.org/wiki/headcanon#Noun) for how to pronouce BMFF

## Installation

### When working with an Xcode project

```
https://github.com/matiaskorhonen/bamf.git
```

### When working with a Swift Package Manager manifest

```swift
// Use the released version
.package(url: "https://github.com/matiaskorhonen/bamf.git", from: "0.1.0")

// Use the development version
.package(url: "https://github.com/matiaskorhonen/bamf.git", branch: "main")
```

```swift
.product(name: "Bamf", package: "bamf")
```

### Usage

```swift
let url = URL(fileURLWithPath: "Tests/BamfTests/Fixtures/DJI_0007.MP4")
let bamf = Bamf(url)

for atom in bamf.children {
  print("Type: \(atom.type)")

  for child in atom.children {
    print("  \(child.type)")
  }
}
```

## Documentation

The library is fully documented with [DocC](https://www.swift.org/documentation/docc/) compatible comments. You can generate and preview the documentation locally using the [Swift-DocC Plugin](https://apple.github.io/swift-docc-plugin/documentation/swiftdoccplugin/) (already included as a dependency):

```sh
# Preview the documentation in a browser
swift package --disable-sandbox preview-documentation --target Bamf
```

## Development

### Formatting and linting

This project uses Swift's built-in formatter (`swift format`) with settings in `.swift-format`.

Run formatting manually:

```sh
swift format --in-place --recursive Sources Tests
```

Run lint checks manually:

```sh
swift format lint --recursive Sources Tests
```

### Lefthook pre-commit hook

This repository uses [lefthook](https://github.com/evilmartians/lefthook) via the [csjones/lefthook-plugin](https://github.com/csjones/lefthook-plugin).

Install hooks after cloning:

```sh
swift package --disable-sandbox lefthook install
```

The pre-commit hook in `lefthook.yml` runs formatter and lint checks on staged Swift files.

## License

MIT License. See <LICENSE> file for details.
