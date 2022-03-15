import Foundation

enum KeyError: Error {
    case invalidKey(String)
}

typealias KeyValidation = (String) throws -> Void

struct PixKeyValidators {
    let email: KeyValidation
    let cpf: KeyValidation
    let phoneNumber: KeyValidation
}

extension PixKeyValidators {
    static let `default` = PixKeyValidators(
        email: emailValidation,
        cpf: cpfValidation,
        phoneNumber: validatePhoneNumber
    )
}

private func emailValidation(email: String) throws {
    let dataDetector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    guard let firstMatch = dataDetector.firstMatch(
        in: email,
        options: NSRegularExpression.MatchingOptions.reportCompletion,
        range: .init(location: 0, length: email.count)
    ),
          firstMatch.range.location != NSNotFound,
          email.contains("@")
    else { throw KeyError.invalidKey(email) }
}

private func cpfValidation(cpf: String) throws {
    func digit(from numbers: ArraySlice<Int>) -> Int {
        var number = numbers.count + 2
        let digit = 11 - numbers.reduce(into: 0) {
            number -= 1
            $0 += $1 * number
        } % 11
        return digit > 9 ? 0 : digit
    }
    
    
    let numbers = cpf.compactMap(\.wholeNumberValue)
    guard numbers.count == 11,
          Set(numbers).count != 1,
          digit(from: numbers.prefix(9)) == numbers[9],
          digit(from: numbers.prefix(10)) == numbers[10]
    else { throw KeyError.invalidKey(cpf) }
    
}

private func validatePhoneNumber(number: String) throws {
    if number.dropFirst().compactMap(\.wholeNumberValue).count == number.count - 1,
       number.starts(with: "+")
    {
        return
    }
    
    throw KeyError.invalidKey(number)
}
