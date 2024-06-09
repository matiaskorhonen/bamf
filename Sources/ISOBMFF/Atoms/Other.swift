import Foundation

// MARK: All atoms that don't have a specific implementation yet
extension Atom {
  class MDIA: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .mdia)
    }
  }
  class MDHD: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .mdhd)
    }
  }
  class HDLR: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .hdlr)
    }
  }
  class MINF: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .minf)
    }
  }
  class VMHD: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .vmhd)
    }
  }
  class DINF: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .dinf)
    }
  }
  class DREF: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .dref)
    }
  }
  class STBL: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .stbl)
    }
  }
  class STSD: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .stsd)
    }
  }
  class STTS: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .stts)
    }
  }
  class STSS: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .stss)
    }
  }
  class STSC: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .stsc)
    }
  }
  class STSZ: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .stsz)
    }
  }
  class STCO: Atom, WithDataInit {
    required init(data: Data) {
      super.init(data: data, type: .stco)
    }
  }
  class Unknown: Atom, WithDataInit {
    var stringValue: String? {
      String(data: data, encoding: .utf8)
    }

    override var debugDescription: String {
      "Atom(type=\(type), stringValue=\(stringValue ?? "nil"))"
    }

    required init(data: Data) {
      super.init(data: data, type: .unknown(type: "TODO"))
    }

    override init(data: Data, type: AtomType) {
      super.init(data: data, type: type)
    }
  }
}
