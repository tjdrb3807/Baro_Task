//
//  ValidationService.swift
//  Baro_Task
//
//  Created by 전성규 on 3/15/25.
//

import Foundation

struct ValidationService {
    static func idValidID(_ id: String) -> Bool {
        // 전체 이메일 형식 검증
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        guard NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: id) else { return false }
        
        // 아디디 부분 추출
        let components = id.split(separator: "@")
        guard let localPart = components.first else { return false }
        
        /// 아이디 부분 정규식 검증
        /// 6~20자, 소문자 & 숫자만 허용, 숫자로 시작 불가
        let idRegex = "^[a-z][a-z0-9]{5,19}$"
        return NSPredicate(format: "SELF MATCHES %@", idRegex).evaluate(with: localPart)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        /// 최소 8자 이상, 대문자 1개, 소문자 1개, 숫자 1개, 특수문자 1개 포함
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*])[A-Za-z\\d!@#$%^&*]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
