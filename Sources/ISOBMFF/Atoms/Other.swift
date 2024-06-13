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
    var stringValue: String? {
      String(data: data, encoding: .utf8)
    }
  }
}
