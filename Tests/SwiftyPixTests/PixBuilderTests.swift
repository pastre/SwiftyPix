//
//  SwiftyPixTests.swift
//  SwiftyPixTests
//
//  Created by Bruno Pastre on 14/03/22.
//

import XCTest

@testable import SwiftyPix

final class PixBuilderTests: XCTestCase {
    
    // MARK: - Unit tests
    
    func test_buildCode_properlyGeneratesCode() throws {
        let expectedString = "00020126300014BR.GOV.BCB.PIX0108dummyKey5204000053039865802BR5909dummyName6009dummyCity6304C860"
        let sut = try PixBuilder(
            key: .custom("dummyKey"),
            merchantName: "dummyName",
            merchantCity: "dummyCity")
        
        let actualCode = sut.buildCode()
        
        XCTAssertEqual(expectedString, actualCode)
    }
    
    func test_set_itShouldAppendNewComponentIfNoneExists() throws {
        let sut = try PixBuilder(key: .custom("dummyKey"),
                             merchantName: "dummyName",
                             merchantCity: "dummyCity")
        
        let actualCode = sut
            .set(.transactionAmount, to: "dummy")
            .buildCode()
        
        XCTAssertTrue(actualCode.contains("5405dummy"),
                      "Produced code does not have the newly appended string: \(actualCode)")
    }
    
    func test_set_itShouldOverrideCurrentValue_ifItAlreadyExists() throws {
        let sut = try PixBuilder(key: .custom("dummyKey"),
                             merchantName: "dummyName",
                             merchantCity: "dummyCity")
            
        let actualCode = sut
            .set(.merchantKey, to: "dummy")
            .buildCode()
        
        XCTAssertFalse(actualCode.contains("dummyKey"),
                       "Produced code did not override existing value: \(actualCode)")
    }
    
    func test_clear_itShouldRemoveValue() throws {
        let sut = try PixBuilder(key: .custom("dummyKey"),
                             merchantName: "dummyName",
                             merchantCity: "dummyCity")
        
        let actualCode = sut
            .clear(id: .merchantKey)
            .buildCode()
        
        XCTAssertFalse(actualCode.contains("dummyKey"),
                       "Produced code did not remove existing value: \(actualCode)")
    }
}
