import Foundation

// MARK: All atoms that don't have a specific implementation yet
extension Atom {
  class MDIA: Atom {
    init(data: Data) {
      super.init(data: data, type: "mdia")
    }
  }
  class MDHD: Atom {
    init(data: Data) {
      super.init(data: data, type: "mdhd")
    }
  }
  class HDLR: Atom {
    init(data: Data) {
      super.init(data: data, type: "hdlr")
    }
  }
  class MINF: Atom {
    init(data: Data) {
      super.init(data: data, type: "minf")
    }
  }
  class VMHD: Atom {
    init(data: Data) {
      super.init(data: data, type: "vmhd")
    }
  }
  class DINF: Atom {
    init(data: Data) {
      super.init(data: data, type: "dinf")
    }
  }
  class DREF: Atom {
    init(data: Data) {
      super.init(data: data, type: "dref")
    }
  }
  class STBL: Atom {
    init(data: Data) {
      super.init(data: data, type: "stbl")
    }
  }
  class STSD: Atom {
    init(data: Data) {
      super.init(data: data, type: "stsd")
    }
  }
  class STTS: Atom {
    init(data: Data) {
      super.init(data: data, type: "stts")
    }
  }
  class STSS: Atom {
    init(data: Data) {
      super.init(data: data, type: "stss")
    }
  }
  class STSC: Atom {
    init(data: Data) {
      super.init(data: data, type: "stsc")
    }
  }
  class STSZ: Atom {
    init(data: Data) {
      super.init(data: data, type: "stsz")
    }
  }
  class STCO: Atom {
    init(data: Data) {
      super.init(data: data, type: "stco")
    }
  }
  class Unknown: Atom {
    // TODO: Fix UserData handling
    //
    // var stringValue: String? {
    //   // Ensure that there is non-null data
    //   let firstNonNull = data.firstIndex(where: { $0 != 0 }) ?? data.startIndex
    //   let startTrimmed = data[firstNonNull...]
    //   guard startTrimmed.count > 0 else { return nil }

    //   let lastNonNull = startTrimmed.lastIndex(where: { $0 != 0 }) ?? startTrimmed.endIndex
    //   let trimmed = startTrimmed[..<lastNonNull]

    //   return String(data: trimmed, encoding: .utf8)
    // }
    // var dateValue: Date? {
    //   guard data.count == 4 else { return nil }

    //   return data.asDate()
    // }
    // var integerValue: UInt64? {
    //   // Only handle ≤ 64-bit data as a possible integer
    //   guard data.count <= (UInt64.bitWidth / UInt8.bitWidth) else { return nil }

    //   return data.asInteger()
    // }

    // private enum CodingKeys: String, CodingKey {
    //   case type
    //   case stringValue
    //   case dateValue
    //   case integerValue
    // }

    // override func encode(to encoder: Encoder) throws {
    //   var container = encoder.container(keyedBy: CodingKeys.self)
    //   try container.encode(type, forKey: .type)
    //   try container.encode(stringValue, forKey: .stringValue)
    //   try container.encode(dateValue, forKey: .dateValue)
    //   try container.encode(integerValue, forKey: .integerValue)
    // }
  }
}
