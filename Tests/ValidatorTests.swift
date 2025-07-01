import XCTest
@testable import GeoGuess

final class ValidatorTests: XCTestCase {

    // MARK: - Email Validation Tests

    func testValidEmail() {
        XCTAssertTrue(Validator.isValidEmail("test@example.com"))
        XCTAssertTrue(Validator.isValidEmail("user.name+tag@sub.domain.co.uk"))
    }

    func testInvalidEmail() {
        XCTAssertFalse(Validator.isValidEmail("plainaddress"))
        XCTAssertFalse(Validator.isValidEmail("@missingusername.com"))
        XCTAssertFalse(Validator.isValidEmail("username@.com"))
        XCTAssertFalse(Validator.isValidEmail("username@domain."))
        XCTAssertFalse(Validator.isValidEmail("username@domain.c"))
        XCTAssertFalse(Validator.isValidEmail("username@domain..com"))
        XCTAssertFalse(Validator.isValidEmail(""))
    }

    // MARK: - Password Validation Tests

    func testValidPassword() {
        XCTAssertTrue(Validator.isValidPassword("12345"))
        XCTAssertTrue(Validator.isValidPassword("password"))
        XCTAssertTrue(Validator.isValidPassword("a long password with spaces"))
    }

    func testInvalidPassword() {
        XCTAssertFalse(Validator.isValidPassword("1234"))
        XCTAssertFalse(Validator.isValidPassword("abc"))
        XCTAssertFalse(Validator.isValidPassword(""))
    }
} 