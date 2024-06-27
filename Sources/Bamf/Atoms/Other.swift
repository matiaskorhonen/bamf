import Foundation

// MARK: All atoms that don't have a specific implementation yet
extension Atom {
  public class MDIA: Atom {
    public init(data: Data) {
      super.init(data: data, type: "mdia")
    }
  }
  public class MDHD: Atom {
    public init(data: Data) {
      super.init(data: data, type: "mdhd")
    }
  }
  public class HDLR: Atom {
    public init(data: Data) {
      super.init(data: data, type: "hdlr")
    }
  }
  public class MINF: Atom {
    public init(data: Data) {
      super.init(data: data, type: "minf")
    }
  }
  public class VMHD: Atom {
    public init(data: Data) {
      super.init(data: data, type: "vmhd")
    }
  }
  public class DINF: Atom {
    public init(data: Data) {
      super.init(data: data, type: "dinf")
    }
  }
  public class DREF: Atom {
    public init(data: Data) {
      super.init(data: data, type: "dref")
    }
  }
  public class STBL: Atom {
    public init(data: Data) {
      super.init(data: data, type: "stbl")
    }
  }
  public class STSD: Atom {
    public init(data: Data) {
      super.init(data: data, type: "stsd")
    }
  }
  public class STTS: Atom {
    public init(data: Data) {
      super.init(data: data, type: "stts")
    }
  }
  public class STSS: Atom {
    public init(data: Data) {
      super.init(data: data, type: "stss")
    }
  }
  public class STSC: Atom {
    public init(data: Data) {
      super.init(data: data, type: "stsc")
    }
  }
  public class STSZ: Atom {
    public init(data: Data) {
      super.init(data: data, type: "stsz")
    }
  }
  public class STCO: Atom {
    public init(data: Data) {
      super.init(data: data, type: "stco")
    }
  }
  public class Unknown: Atom {}
}
