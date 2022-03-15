public struct PixKey: PixRawValue {
    
    enum KeyValidationStrategy {
        case email, phone, cpf
    }
    public let pixValue: String
    let validationStrategy: KeyValidationStrategy?
    
    private init(pixValue: String, validationStrategy: KeyValidationStrategy?) {
        self.pixValue = pixValue
        self.validationStrategy = validationStrategy
    }
    
    /// Represents an email as the Pix Key
    /// - Parameter string: The email to be validated
    /// - Returns: A properly formatted Pix Key with the email
    public static func email(_ string: String) -> PixKey {
        self.init(pixValue: string, validationStrategy: .email)
    }
    
    /// Represents a phone number as the Pix transaction key
    /// - Parameters:
    ///   - number: Only numbers representing the phone number
    ///   - ddd: Only numbers representing the region code
    ///   - countryCode: Only numbers representing the country code
    /// - Returns: A properly formatted Pix Key with the phone number
    public static func phoneNumber(number: String, ddd: String, countryCode: String) -> PixKey {
        self.init(pixValue: "+" + countryCode + ddd + number,
                  validationStrategy: .phone)
    }
    
    /// Represents a CPF as the Pix transaction key
    /// - Parameter string: The CPF to be validated
    /// - Returns: A properly formatted Pix Key with the CPF
    public static func cpf(_ string: String) -> PixKey {
        self.init(pixValue: string, validationStrategy: .cpf)
    }
    
    /// Represents any string as the Pix transaction key. This won't be validated, so it's behaviour is unpredictable. Use it at your own risk
    /// - Parameter string: the string that will be used in the Pix transaction
    /// - Returns: A PixKey with any string as it's value
    public static func custom(_ string: String) -> PixKey {
        self.init(pixValue: string, validationStrategy: nil)
    }
}
