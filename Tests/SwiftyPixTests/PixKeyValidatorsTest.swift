import XCTest

@testable import SwiftyPix

final class PixKeyValidatorsTests: XCTestCase {
    
    func test_emailValidation_whenEmailIsValid_itShouldNotThrow() {
        let emailStub = "a@validEmail.com"
        let sut = PixKeyValidators.default.email
        
        XCTAssertNoThrow(try sut(emailStub))
    }
    
    func test_emailValidation_whenEmailIsInvalid_itShouldThrow() {
        let sut = PixKeyValidators.default.email
        
        XCTAssertThrowsError(try sut("a@validEmail"))
        XCTAssertThrowsError(try sut("a@validEmail."))
        XCTAssertThrowsError(try sut("avalidEmail.com"))
        XCTAssertThrowsError(try sut("@validEmail"))
        XCTAssertThrowsError(try sut("@validEmail.com"))
    }
    
    func test_cpfValidation_whenCpfIsValid_itShouldNotThrow() {
        let sut = PixKeyValidators.default.cpf
        XCTAssertNoThrow(try sut("22621638554"))
        XCTAssertNoThrow(try sut("226.216.385-54"))
    }
    
    func test_cpfValidation_whenCpfDigitCountIsWrong_itShouldThrow() {
        let sut = PixKeyValidators.default.cpf
        XCTAssertThrowsError(try sut("2262163855"))
        XCTAssertThrowsError(try sut("226.216.385-500"))
    }
    
    func test_cpfValidation_whenCpfDigitsAreTheSame_itShouldThrow() {
        let sut = PixKeyValidators.default.cpf
        XCTAssertThrowsError(try sut(.init(repeating: "1", count: 11)))
    }
    
    func test_cpfValidation_whenNinthDigitMismatch_itShouldThrow() {
        let sut = PixKeyValidators.default.cpf
        XCTAssertThrowsError(try sut(.init(repeating: "22621638154", count: 11)))
    }
    
    func test_cpfValidation_whenTenthDigitMismatch_itShouldThrow() {
        let sut = PixKeyValidators.default.cpf
        XCTAssertThrowsError(try sut(.init(repeating: "22621638514", count: 11)))
    }
    
    func test_validatePhoneNumber_whenNumberIsValid_itShouldNotThrow() {
        let sut = PixKeyValidators.default.phoneNumber
        
        XCTAssertNoThrow(try sut("+5541985444313"))
    }
    
    func test_validatePhoneNumber_whenNumberHasAlphabeticCharacters_itShouldThrow() {
        let sut = PixKeyValidators.default.phoneNumber
        XCTAssertThrowsError(try sut("+55419854r44313"))
    }
    
    func test_validatePhoneNumber_whenNumberIsMissingPlus_itShouldThrow() {
        let sut = PixKeyValidators.default.phoneNumber
        XCTAssertThrowsError(try sut("5541985444313"))
    }
}
