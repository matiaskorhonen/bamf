// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Bamf
import Foundation

@main
struct BamfCLI: ParsableCommand {
  enum OutputFormat: String, ExpressibleByArgument {
    case text
    case json
  }

  static let configuration = CommandConfiguration(
    abstract: "BAMF CLI",
    discussion: """
        Output parsed data from ISOBMFF files as parsed by Bamf!

        Mostly for debugging and testing purposes.
      """,
    helpNames: .shortAndLong
  )

  @Argument(help: "source MP4 file(s)", transform: URL.init(fileURLWithPath:))
  var source: [URL] = []

  @Option(name: .shortAndLong, help: "output format (text or json)")
  var format: OutputFormat = .text

  mutating func run() throws {
    for url in source {
      let bamf = try Bamf(url)

      switch format {
      case .text:
        print(formatAtomsText(bamf.children))
      case .json:
        print(formatAtomsJSON(bamf.children))
      }
    }
  }
}

// MARK: - Text format (similar to mp4dump)

private func formatAtomsText(_ atoms: [Atom], indent: Int = 0) -> String {
  atoms.map { formatAtomText($0, indent: indent) }.joined(separator: "\n")
}

private func formatAtomText(_ atom: Atom, indent: Int = 0) -> String {
  let prefix = String(repeating: "  ", count: indent)
  // atom.data starts after the 8-byte size+type header; full-box version+flags are included in data
  let payloadSize = atom.data.count - (atom.headerSize - 8)
  var lines: [String] = []
  let propPrefix = "\(prefix)  "

  var header = "\(prefix)[\(atom.type)] size=\(atom.headerSize)+\(payloadSize)"

  // Append non-zero flags for full boxes
  if atom.headerSize == 12 {
    let flagsInt = combinedFlagsInt(atom)
    if flagsInt != 0 {
      header += ", flags=\(String(flagsInt, radix: 16))"
    }
  }
  lines.append(header)

  // Type-specific properties
  switch atom {
  case let a as Atom.FTYP:
    lines.append("\(propPrefix)major_brand = \(a.majorBrand ?? "")")
    lines.append("\(propPrefix)minor_version = \(a.minorVersion)")
    for brand in a.compatibleBrands {
      lines.append("\(propPrefix)compatible_brand = \(brand)")
    }

  case let a as Atom.MVHD:
    lines.append("\(propPrefix)timescale = \(a.timeScale)")
    lines.append("\(propPrefix)duration = \(a.duration)")
    lines.append("\(propPrefix)duration(ms) = \(durationMs(a.duration, timeScale: a.timeScale))")

  case let a as Atom.TKHD:
    let flagsInt = combinedFlagsInt(a)
    lines.append("\(propPrefix)enabled = \((flagsInt & 0x01) != 0 ? 1 : 0)")
    lines.append("\(propPrefix)id = \(a.trackID)")
    lines.append("\(propPrefix)duration = \(a.duration)")
    lines.append("\(propPrefix)width = \(a.width)")
    lines.append("\(propPrefix)height = \(a.height)")

  case let a as Atom.MDHD:
    lines.append("\(propPrefix)timescale = \(a.timeScale)")
    lines.append("\(propPrefix)duration = \(a.duration)")
    lines.append("\(propPrefix)duration(ms) = \(durationMs(a.duration, timeScale: a.timeScale))")
    lines.append("\(propPrefix)language = \(a.language)")

  case let a as Atom.HDLR:
    lines.append("\(propPrefix)handler_type = \(a.handlerType)")
    lines.append("\(propPrefix)handler_name = \(a.name)")

  case let a as Atom.VMHD:
    let opcolorStr = a.opcolor.map { String(format: "%04x", $0) }.joined(separator: ",")
    lines.append("\(propPrefix)graphics_mode = \(a.graphicsMode)")
    lines.append("\(propPrefix)op_color = \(opcolorStr)")

  case let a as Atom.STTS:
    lines.append("\(propPrefix)entry_count = \(a.entryCount)")

  case let a as Atom.STSC:
    lines.append("\(propPrefix)entry_count = \(a.entryCount)")

  case let a as Atom.STSS:
    lines.append("\(propPrefix)entry_count = \(a.entryCount)")

  case let a as Atom.STCO:
    lines.append("\(propPrefix)entry_count = \(a.entryCount)")

  case let a as Atom.STSZ:
    lines.append("\(propPrefix)sample_size = \(a.sampleSize)")
    lines.append("\(propPrefix)sample_count = \(a.sampleCount)")

  case let a as Atom.STSD:
    lines.append("\(propPrefix)entry_count = \(a.entryCount)")

  default:
    break
  }

  // Children
  for child in atomChildren(atom) {
    lines.append(formatAtomText(child, indent: indent + 1))
  }

  return lines.joined(separator: "\n")
}

// MARK: - JSON format (similar to mp4dump --format json)

private func formatAtomsJSON(_ atoms: [Atom]) -> String {
  let dicts = atoms.map { atomToDict($0) }
  guard
    let data = try? JSONSerialization.data(
      withJSONObject: dicts, options: [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes])
  else {
    return "[]"
  }
  return String(data: data, encoding: .utf8) ?? "[]"
}

private func atomToDict(_ atom: Atom) -> [String: Any] {
  // atom.data does not include the 8-byte size+type header, so total size = data.count + 8
  let totalSize = atom.data.count + 8
  var dict: [String: Any] = [
    "header_size": atom.headerSize,
    "name": atom.type,
    "size": totalSize,
  ]

  switch atom {
  case let a as Atom.FTYP:
    if let brand = a.majorBrand { dict["major_brand"] = brand }
    dict["minor_version"] = a.minorVersion
    dict["compatible_brands"] = a.compatibleBrands

  case let a as Atom.MVHD:
    dict["timescale"] = a.timeScale
    dict["duration"] = a.duration
    dict["duration(ms)"] = durationMs(a.duration, timeScale: a.timeScale)

  case let a as Atom.TKHD:
    let flagsInt = combinedFlagsInt(a)
    dict["flags"] = flagsInt
    dict["enabled"] = (flagsInt & 0x01) != 0 ? 1 : 0
    dict["id"] = a.trackID
    dict["duration"] = a.duration
    dict["width"] = Double(truncating: a.width as NSDecimalNumber)
    dict["height"] = Double(truncating: a.height as NSDecimalNumber)

  case let a as Atom.MDHD:
    dict["timescale"] = a.timeScale
    dict["duration"] = a.duration
    dict["duration(ms)"] = durationMs(a.duration, timeScale: a.timeScale)
    dict["language"] = a.language

  case let a as Atom.HDLR:
    dict["handler_type"] = a.handlerType
    dict["handler_name"] = a.name

  case let a as Atom.VMHD:
    let flagsInt = combinedFlagsInt(a)
    dict["flags"] = flagsInt
    dict["graphics_mode"] = a.graphicsMode
    dict["op_color"] = a.opcolor.map { String(format: "%04x", $0) }.joined(separator: ",")

  case let a as Atom.STTS:
    dict["entry_count"] = a.entryCount

  case let a as Atom.STSC:
    dict["entry_count"] = a.entryCount

  case let a as Atom.STSS:
    dict["entry_count"] = a.entryCount

  case let a as Atom.STCO:
    dict["entry_count"] = a.entryCount

  case let a as Atom.STSZ:
    dict["sample_size"] = a.sampleSize
    dict["sample_count"] = a.sampleCount

  case let a as Atom.STSD:
    dict["entry_count"] = a.entryCount

  default:
    break
  }

  let children = atomChildren(atom)
  if !children.isEmpty {
    dict["children"] = children.map { atomToDict($0) }
  }

  return dict
}

// MARK: - Helpers

/// Returns the children of an atom, handling special cases like UDTA.
private func atomChildren(_ atom: Atom) -> [Atom] {
  if let udta = atom as? Atom.UDTA {
    return udta.userData
  }
  return atom.children
}

/// Returns the combined 24-bit flags integer from a full box atom's flags bytes.
private func combinedFlagsInt(_ atom: Atom) -> Int {
  guard atom.data.count >= 4 else { return 0 }
  let b0 = Int(atom.data[atom.data.startIndex + 1])
  let b1 = Int(atom.data[atom.data.startIndex + 2])
  let b2 = Int(atom.data[atom.data.startIndex + 3])
  return (b0 << 16) | (b1 << 8) | b2
}

/// Returns duration in milliseconds (truncated).
private func durationMs(_ duration: UInt64, timeScale: UInt32) -> UInt64 {
  guard timeScale > 0 else { return 0 }
  return (duration * 1000) / UInt64(timeScale)
}

