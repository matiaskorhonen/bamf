/// A property wrapper that makes a property ignored during `Codable` encoding and decoding.
///
/// Wrapped properties are encoded as `nil` and decoded as `nil`, allowing them to be
/// excluded from `Codable` representations while still being settable in code.
@propertyWrapper
public struct CodableIgnored<T>: Codable {
  /// The underlying value of the property.
  public var wrappedValue: T?

  /// Creates a new instance with the given wrapped value.
  ///
  /// - Parameter wrappedValue: The initial value of the wrapped property.
  public init(wrappedValue: T?) {
    self.wrappedValue = wrappedValue
  }

  /// Decodes the property by always setting the wrapped value to `nil`.
  public init(from decoder: Decoder) throws {
    self.wrappedValue = nil
  }

  /// Encoding is a no-op; the property is intentionally excluded from the encoded output.
  public func encode(to encoder: Encoder) throws {
    // Do nothing
  }
}

extension KeyedDecodingContainer {
  public func decode<T>(
    _ type: CodableIgnored<T>.Type,
    forKey key: Self.Key
  ) throws -> CodableIgnored<T> {
    return CodableIgnored(wrappedValue: nil)
  }
}

extension KeyedEncodingContainer {
  public mutating func encode<T>(
    _ value: CodableIgnored<T>,
    forKey key: KeyedEncodingContainer<K>.Key
  ) throws {
    // Do nothing
  }
}
