import CoreImage

/// Creates a builder with all mandatory parameters for the transaction to work. The parameters can be changed via `set` method. It will throw when the Pix Key is invalid. You don't need to validate emails or CPFs, and phone numbers should be numbers only. If you want to skip validation, you can choose to use `.custom` as the key
public final class PixBuilder {
    private var aggregator: [PixComponent] = []
    /// - Parameters:
    ///   - key: The PIX key that should be used for the transaction
    ///   - merchantName: The name of the person that is asking for money
    ///   - merchantCity: The city in which the transaction will occur
    ///   - payloadFormatIndicator: Payload version. Defaults to 1
    ///   - currency: The currency in which the transaction is happening. Defaults to BRL
    ///   - merchantCategoryCode: Merchant category code. Defaults to 0000
    ///   - countryCode: The country in which the transaction is happening. Defaults to Brazil
    ///   - merchantGui: The merchant's Globally Unique Identifier. Defaults to Pix's
    public convenience init(
        key: PixKey,
        merchantName: String,
        merchantCity: String,
        payloadFormatIndicator: String = PixConstants.Metadata.payloadFormatInformation,
        currency: Int = PixConstants.Currency.brl,
        merchantCategoryCode: String = PixConstants.Merchant.categoryCode,
        countryCode: String = PixConstants.Country.brazil,
        merchantGui: String = PixConstants.Merchant.pixGui
    ) throws {
        try self.init(key: key)
        aggregator.append(.init(id: .payloadFormatIndicator, value: payloadFormatIndicator))
        
        aggregator.append(.init(id: .merchantAccountInformation, value: [
            PixComponent(id: .merchantGui, value: merchantGui),
            PixComponent(id: .merchantKey, value: key)
        ]))
        aggregator.append(.init(id: .merchantName, value: merchantName))
        aggregator.append(.init(id: .merchantCity, value: merchantCity))
        aggregator.append(.init(id: .currencyCode, value: currency))
        aggregator.append(.init(id: .merchantCategoryCode, value: merchantCategoryCode))
        aggregator.append(.init(id: .countryCode, value: countryCode))
    }
    
    init(key: PixKey, validators: PixKeyValidators = .default) throws {
        switch key.validationStrategy {
        case .email:
            try validators.email(key.pixValue)
        case .phone:
            try validators.phoneNumber(key.pixValue)
        case .cpf:
            try validators.cpf(key.pixValue)
        case .none:
            return
        }
    }
    
    ///  Adds a parameter to the current pix code generation. The parameter is overwritten if it already exists, or created if it does not
    /// - Parameters:
    ///   - id: The ID of the parameter to be set
    ///   - value: The value to set the parameter to
    /// - Returns: Updated builder with the updated parameter
    public func set<T>(_ id: PixId, to value: T) -> Self where T: PixRawValue {
        aggregator.removeAll(where: { $0.hasId(id) })
        aggregator.append(.init(id: id, value: value))
        return self
    }
    
    /// Removes a pix parameter
    /// - Parameter id: The ID of the parameter to be removed
    /// - Returns: A new builder without the parameter
    public func clear(id: PixId) -> Self {
        aggregator.removeAll(where: { $0.hasId(id) })
        return self
    }
    
    /// Creates a string representing the current pix transaction
    /// - Returns: A string representing the current pix transaction
    public func buildCode() -> String {
        appendingCRC16()
            ._buildCode()
    }
    
    /// Returns an image representing the code with the current pix transaction that can be scanned to complete the transaction
    /// - Returns: A CIImage representing the current code, or nil if the image generation fails
    public func buildQRCode() -> CIImage? {
        let code = buildCode()
        guard let data = code.data(using: .ascii),
              let filter = CIFilter(name: "CIQRCodeGenerator")
        else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        return filter.outputImage
    }
    
    // MARK: - Helpers
    
    private func _buildCode() -> String {
        aggregator
            .sorted(by: { $0.id.id < $1.id.id })
            .map { $0.formatted() }
            .joined(separator: "")
    }
    
    private func appendingCRC16() -> Self {
        let code = _buildCode() + "6304"
        guard let bytes = code.data(using: .utf8) else { return self }
        let calculatedCrc = calculateCrc(using: bytes)
        let formattedCrc = String(format: "%02X", calculatedCrc)
        aggregator.append(.init(id: .crc16,
                                value: formattedCrc))
        return self
    }
    
    
    private func calculateCrc(using bytes: Data) -> UInt16 {
        let crcTable = PixConstants.CRC.crcTable
        var crc: UInt16 = 0xFFFF
        bytes.map({ UInt16($0) })
            .forEach { byte in
                let j = (byte ^ (crc >> 8)) & 0xFF
                crc = crcTable[Int(j)] ^ (crc << 8)
            }
        
        return ((crc ^ 0) & 0xFFFF)
    }
}
