public struct PixComponent: Identifiable {
    public let id: PixId
    let value: PixRawValue
    
    public init(id: PixId, value: PixRawValue) {
        self.id = id
        self.value = value
    }
    
    func formatted() -> String {
        let id = id.id
        let value = value.pixValue
        let lenght = value.count
        return id + lenght + value
    }
}

extension PixComponent {
    func hasId(_ id: PixId) -> Bool {
        if let value = self.value as? [PixComponent] {
            return value.contains(where: { $0.hasId(id) })
        }
        return self.id == id
    }
}
