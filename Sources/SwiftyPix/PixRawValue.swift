public protocol PixRawValue {
    var pixValue: String { get }
}

extension Int: PixRawValue {
    public var pixValue: String { .init(format: "%02d", self) }
}

extension String: PixRawValue {
    public var pixValue: String { self }
}

extension Array: PixRawValue where Element == PixComponent {
    public var pixValue: String {
        map { $0.formatted() }.joined(separator: "")
    }
}

func + (_ a: PixRawValue, _ b: PixRawValue) -> String {
    a.pixValue + b.pixValue
}
