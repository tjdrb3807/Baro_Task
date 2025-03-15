//
//  ValidationServiceTests.swift
//  Baro_TaskTests
//
//  Created by 전성규 on 3/15/25.
//

import XCTest
@testable import Baro_Task

final class ValidationServiceTests: XCTestCase {
    
    // 유효한 ID 테스트
    func testValidEmails() {
        XCTAssertTrue(ValidationService.idValidID("abc123@gmail.com"))
        XCTAssertTrue(ValidationService.idValidID("testuser99@naver.com"))
        XCTAssertTrue(ValidationService.idValidID("validid12@yahoo.com"))
    }
    
    // 잘못된 이메일 형식 테스트
    func testInvalidEmails() {
        XCTAssertFalse(ValidationService.idValidID("abc.com")) // 이메일 형식 아님
        XCTAssertFalse(ValidationService.idValidID("abc@@gmail.com")) // 잘못된 이메일 형식
        XCTAssertFalse(ValidationService.idValidID("abc@gmail")) // 도메인 형식이 잘못됨
    }
    
    // 유효하지 않은 로컬 파트 테스트
    func testInvalidLocalParts() {
        XCTAssertFalse(ValidationService.idValidID("Abcdef@gmail.com")) // 대문자 포함
        XCTAssertFalse(ValidationService.idValidID("1abc123@gmail.com")) // 숫자로 시작
        XCTAssertFalse(ValidationService.idValidID("abc@gmail.com")) // 6자 미만
        XCTAssertFalse(ValidationService.idValidID("abcdefghijabcdefghiji@gmail.com")) // 20자 초과
        XCTAssertFalse(ValidationService.idValidID("abc!@gmail.com")) // 특수문자 포함
    }
    
    // 유효한 비밀번호 테스트
    func testValidPasswords() {
        XCTAssertTrue(ValidationService.isValidPassword("Aa1!5678")) // 조건 충족
        XCTAssertTrue(ValidationService.isValidPassword("Secure#Pass1")) // 조건 충족
        XCTAssertTrue(ValidationService.isValidPassword("Str0ng@Passw0rd")) // 조건 충족
    }
    
    // 유효하지 않은 비밀번호 테스트
    func testInvalidPasswords() {
        XCTAssertFalse(ValidationService.isValidPassword("abcd1234")) // 대문자 & 특수문자 없음
        XCTAssertFalse(ValidationService.isValidPassword("ABCDEFGH")) // 숫자 & 특수문자 없음
        XCTAssertFalse(ValidationService.isValidPassword("abcdEFGH")) // 숫자 & 특수문자 없음
        XCTAssertFalse(ValidationService.isValidPassword("abcdEF12")) // 특수문자 없음
        XCTAssertFalse(ValidationService.isValidPassword("Aa1!")) // 8자 미만
    }
}
