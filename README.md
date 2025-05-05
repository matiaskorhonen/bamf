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
let url = URL(fileURLWithPath: "Tests/BamfTests/Resources/DJI_0007.MP4")
let bamf = Bamf(url)

for atom in bamf.children {
  print("Type: \(atom.type)")

  for child in atom.children {
    print("  \(child.type)")
  }
}
```

## License

MIT License. See <LICENSE> file for details.
