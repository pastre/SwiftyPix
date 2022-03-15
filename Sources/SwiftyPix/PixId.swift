public struct PixId: ExpressibleByStringLiteral, Hashable {
    let id: String
    public init(stringLiteral value: StringLiteralType) {
        id = value
    }
}

public extension PixId {
    static let payloadFormatIndicator: Self = "00"
    static let pointOfIndication: Self = "01"
    static let merchantCategoryCode: Self = "52"
    static let currencyCode: Self = "53"
    static let merchantAccountInformation: Self = "26"
    static let merchantName: Self = "59"
    static let merchantCity: Self = "60"
    static let countryCode: Self = "58"
    static let merchantKey: Self = "01"
    static let merchantGui: Self = "00"
    static let crc16: Self = "63"
    static let postalCode: Self = "61"
    static let transactionAmount: Self = "54"
    // TODO create all ids
}
