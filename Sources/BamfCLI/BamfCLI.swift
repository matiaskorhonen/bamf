// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Bamf
import Foundation
#if canImport(Darwin)
  import Darwin
#elseif canImport(Glibc)
  import Glibc
#endif

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

  @Flag(name: .customLong("no-color"), help: "Disable colored output")
  var noColor: Bool = false

  mutating func run() throws {
    let colorEnabled = !noColor && isatty(STDOUT_FILENO) != 0
    for url in source {
      let bamf = try Bamf(url)

      switch format {
      case .text:
        print(formatAtomsText(bamf.children, colorEnabled: colorEnabled))
      case .json:
        print(formatAtomsJSON(bamf.children))
      }
    }
  }
}

// MARK: - Text format (similar to mp4dump)

private func formatAtomsText(_ atoms: [Atom], indent: Int = 0, colorEnabled: Bool = false) -> String {
  atoms.map { formatAtomText($0, indent: indent, colorEnabled: colorEnabled) }.joined(separator: "\n")
}

private func formatAtomText(_ atom: Atom, indent: Int = 0, colorEnabled: Bool = false) -> String {
  let prefix = String(repeating: "  ", count: indent)
  // atom.data starts after the 8-byte size+type header; full-box version+flags are included in data
  let payloadSize = atom.data.count - (atom.headerSize - 8)
  var lines: [String] = []
  let propPrefix = "\(prefix)  "

  let typeStr = ansi("[\(atom.type)]", ANSI.bold, ANSI.cyan, enabled: colorEnabled)
  let sizeStr = ansi("size=\(atom.headerSize)+\(payloadSize)", ANSI.dim, enabled: colorEnabled)
  var header = "\(prefix)\(typeStr) \(sizeStr)"

  // Append non-zero flags for full boxes
  if atom.headerSize == 12 {
    if atom.flagsInt != 0 {
      header += ansi(", flags=\(String(atom.flagsInt, radix: 16))", ANSI.dim, enabled: colorEnabled)
    }
  }
  lines.append(header)

  let prop: (String, Any) -> String = { key, value in
    let keyStr = ansi(key, ANSI.yellow, enabled: colorEnabled)
    return "\(propPrefix)\(keyStr) = \(value)"
  }

  // Type-specific properties
  switch atom {
  case let a as Atom.FTYP:
    lines.append(prop("major_brand", a.majorBrand ?? ""))
    lines.append(prop("minor_version", a.minorVersion))
    for brand in a.compatibleBrands {
      lines.append(prop("compatible_brand", brand))
    }

  case let a as Atom.MVHD:
    lines.append(prop("timescale", a.timeScale))
    lines.append(prop("duration", a.duration))
    lines.append(prop("duration(ms)", Atom.durationMs(a.duration, timeScale: a.timeScale)))

  case let a as Atom.TKHD:
    let flagsInt = a.flagsInt
    lines.append(prop("enabled", (flagsInt & 0x01) != 0 ? 1 : 0))
    lines.append(prop("id", a.trackID))
    lines.append(prop("duration", a.duration))
    lines.append(prop("width", a.width))
    lines.append(prop("height", a.height))

  case let a as Atom.MDHD:
    lines.append(prop("timescale", a.timeScale))
    lines.append(prop("duration", a.duration))
    lines.append(prop("duration(ms)", Atom.durationMs(a.duration, timeScale: a.timeScale)))
    lines.append(prop("language", a.language))

  case let a as Atom.HDLR:
    lines.append(prop("handler_type", a.handlerType))
    lines.append(prop("handler_name", a.name))

  case let a as Atom.VMHD:
    let opcolorStr = a.opcolor.map { String(format: "%04x", $0) }.joined(separator: ",")
    lines.append(prop("graphics_mode", a.graphicsMode))
    lines.append(prop("op_color", opcolorStr))

  case let a as Atom.STTS:
    lines.append(prop("entry_count", a.entryCount))

  case let a as Atom.STSC:
    lines.append(prop("entry_count", a.entryCount))

  case let a as Atom.STSS:
    lines.append(prop("entry_count", a.entryCount))

  case let a as Atom.STCO:
    lines.append(prop("entry_count", a.entryCount))

  case let a as Atom.STSZ:
    lines.append(prop("sample_size", a.sampleSize))
    lines.append(prop("sample_count", a.sampleCount))

  case let a as Atom.STSD:
    lines.append(prop("entry_count", a.entryCount))

  case let a as Atom.ILSTData:
    lines.append(prop("type", a.dataType))
    lines.append(prop("lang", a.locale))
    if let value = a.value {
      lines.append(prop("value", value))
    }

  default:
    break
  }

  // Children
  for child in atom.displayChildren {
    lines.append(formatAtomText(child, indent: indent + 1, colorEnabled: colorEnabled))
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
    dict["duration(ms)"] = Atom.durationMs(a.duration, timeScale: a.timeScale)

  case let a as Atom.TKHD:
    dict["flags"] = a.flagsInt
    dict["enabled"] = (a.flagsInt & 0x01) != 0 ? 1 : 0
    dict["id"] = a.trackID
    dict["duration"] = a.duration
    dict["width"] = Double(truncating: a.width as NSDecimalNumber)
    dict["height"] = Double(truncating: a.height as NSDecimalNumber)

  case let a as Atom.MDHD:
    dict["timescale"] = a.timeScale
    dict["duration"] = a.duration
    dict["duration(ms)"] = Atom.durationMs(a.duration, timeScale: a.timeScale)
    dict["language"] = a.language

  case let a as Atom.HDLR:
    dict["handler_type"] = a.handlerType
    dict["handler_name"] = a.name

  case let a as Atom.VMHD:
    dict["flags"] = a.flagsInt
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

  case let a as Atom.ILSTData:
    dict["type"] = a.dataType
    dict["lang"] = a.locale
    if let value = a.value {
      dict["value"] = value
    }

  default:
    break
  }

  let children = atom.displayChildren
  if !children.isEmpty {
    dict["children"] = children.map { atomToDict($0) }
  }

  return dict
}

